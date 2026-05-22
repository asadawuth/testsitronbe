import { prisma } from "../model/prisma";
import { registerAdminDto, UpdateUserDto } from "./user.dto";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import {
  LoginResponse,
  RegisterResponse,
  ChangePasswordDto,
  UserSystemResponse,
} from "./usertype";
import { getPagination, paginationMeta } from "../utils/pagination";
export class UserService {
  async register(data: registerAdminDto): Promise<RegisterResponse> {
    const exists = await prisma.users.findFirst({
      where: { email: data.email },
    });
    if (exists) {
      throw new Error("Email already exists");
    }
    const hashedPassword = await bcrypt.hash(data.password, 10);
    const user = await prisma.users.create({
      data: {
        ...data,
        password: hashedPassword,
      },
    });
    return {
      data: {
        id: user.id,
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        role: user.role,
      },
    };
  }

  async login(
    data: { identifier: string; password: string },
    device?: string,
    ipAddress?: string
  ): Promise<LoginResponse> {
    const { identifier, password } = data;
    const user = await prisma.users.findFirst({
      where: {
        OR: [{ email: identifier }, { tel: identifier }],
      },
    });

    if (!user) {
      throw new Error("ไม่พบผู้ใช้งาน");
    }

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      throw new Error("รหัสผ่านไม่ถูกต้อง");
    }

    const accessToken = jwt.sign(
      {
        userId: user.id,
        role: user.role,
      },
      process.env.JWT_SECRET!,
      {
        expiresIn: "15m",
      }
    );

    const refreshToken = jwt.sign(
      {
        userId: user.id,
      },
      process.env.JWT_REFRESH_SECRET!,
      {
        expiresIn: "7d",
      }
    );

    await prisma.refresh_tokens.create({
      data: {
        user_id: user.id,
        token: refreshToken,
        device: device?.slice(0, 100) || "unknown-device",
        expires_at: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
        // expires_at: new Date(Date.now() + 5 * 60 * 1000),
      },
    });

    return {
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        tel: user.tel,
        role: user.role,
      },
    };
  }

  async logout(token: string) {
    await prisma.refresh_tokens.updateMany({
      where: {
        token: token,
      },
      data: {
        is_revoked: true,
      },
    });
    return {
      message: "logout success",
    };
  }

  async logoutAll(userId: number) {
    await prisma.refresh_tokens.updateMany({
      where: {
        user_id: userId,
        is_revoked: false,
      },
      data: {
        is_revoked: true,
      },
    });

    return {
      message: "logout all success",
    };
  }

  async refreshToken(token: string) {
    const storedToken = await prisma.refresh_tokens.findFirst({
      where: {
        token,
        is_revoked: false,
      },
    });
    if (!storedToken) {
      throw new Error("Invalid refresh token");
    }
    const decoded = jwt.verify(token, process.env.JWT_REFRESH_SECRET!) as {
      userId: number;
    };
    const user = await prisma.users.findUnique({
      where: { id: decoded.userId },
    });
    if (!user) {
      throw new Error("User not found");
    }

    const newAccessToken = jwt.sign(
      {
        userId: user.id,
        role: user.role,
      },
      process.env.JWT_SECRET!,
      { expiresIn: "15m" }
    );

    return {
      accessToken: newAccessToken,
    };
  }

  async changePassword(userId: number, data: ChangePasswordDto) {
    const user = await prisma.users.findUnique({
      where: {
        id: userId,
      },
    });

    if (!user) {
      throw new Error("ไม่พบผู้ใช้งาน");
    }

    const isMatch = await bcrypt.compare(data.oldPassword, user.password);

    if (!isMatch) {
      throw new Error("รหัสผ่านเก่าไม่ถูกต้อง");
    }

    const hashedPassword = await bcrypt.hash(data.newPassword, 10);

    await prisma.users.update({
      where: {
        id: userId,
      },
      data: {
        password: hashedPassword,
      },
    });

    return {
      message: "Change password success",
    };
  }

  async updateUser(userId: number, data: UpdateUserDto) {
    const user = await prisma.users.findUnique({
      where: {
        id: userId,
      },
    });

    if (!user) {
      throw new Error("ไม่พบผู้ใช้งาน");
    }
    if (data.email && data.email !== user.email) {
      const existingEmail = await prisma.users.findUnique({
        where: {
          email: data.email,
        },
      });

      if (existingEmail) {
        throw new Error("อีเมลนี้ถูกใช้งานแล้ว");
      }
    }

    const updatedUser = await prisma.users.update({
      where: {
        id: userId,
      },
      data,
      select: {
        id: true,
        first_name: true,
        last_name: true,
        tel: true,
        email: true,
        role: true,
      },
    });

    return {
      message: "อัปเดตข้อมูลสำเร็จ",
      user: updatedUser,
    };
  }

  async userSystem(page: number, limit: number): Promise<UserSystemResponse> {
    const {
      skip,
      page: currentPage,
      limit: currentLimit,
    } = getPagination(page, limit);

    const [total, usersystem] = await Promise.all([
      prisma.refresh_tokens.count(),
      prisma.refresh_tokens.findMany({
        skip,
        take: currentLimit,
        orderBy: {
          created_at: "desc",
        },
        select: {
          user_id: true,
          device: true,
          is_revoked: true,
          expires_at: true,
          created_at: true,
          users: {
            select: {
              role: true,
            },
          },
        },
      }),
    ]);

    return {
      message: "Admin History Successfully",
      pagination: paginationMeta(total, currentPage, currentLimit),
      data: usersystem.map((item) => ({
        user_id: item.user_id,
        role: item.users.role,
        device: item.device,
        is_revoked: item.is_revoked,
        expires_at: item.expires_at,
        created_at: item.created_at,
      })),
    };
  }
}
