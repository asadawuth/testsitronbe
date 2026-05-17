import type { Request, Response } from "express";
import { UserService } from "./user.service";
import { registerAdminDto } from "./user.dto";

export class UserController {
  constructor(private readonly userService: UserService) {}

  register = async (req: Request, res: Response) => {
    try {
      const body: registerAdminDto = req.body;
      const result = await this.userService.register(body);
      return res.json(result);
    } catch (err: any) {
      return res.status(400).json({
        message: err.message,
      });
    }
  };

  login = async (req: Request, res: Response) => {
    try {
      const device = req.headers["user-agent"] as string;
      const ipAddress =
        (req.headers["x-forwarded-for"] as string) || req.socket.remoteAddress;

      const result = await this.userService.login(
        req.body,
        device,
        String(ipAddress),
      );

      res.cookie("refreshToken", result.refreshToken, {
        httpOnly: true,
        secure: false, // production => true
        sameSite: "strict",
        maxAge: 7 * 24 * 60 * 60 * 1000,
      });

      return res.status(200).json({
        message: "login success",
        accessToken: result.accessToken,
        user: result.user,
      });
    } catch (err: any) {
      return res.status(400).json({
        message: err.message,
      });
    }
  };

  logout = async (req: Request, res: Response) => {
    try {
      const token = req.cookies.refreshToken;

      if (!token) {
        return res.status(400).json({
          message: "Refresh token not found",
        });
      }

      await this.userService.logout(token);

      res.clearCookie("refreshToken");

      return res.status(200).json({
        message: "logout success",
      });
    } catch (err: any) {
      return res.status(400).json({
        message: err.message,
      });
    }
  };

  logoutAll = async (req: Request, res: Response) => {
    try {
      const userId = req.user?.userId;
      if (!userId) {
        return res.status(401).json({
          message: "Unauthorized",
        });
      }
      await this.userService.logoutAll(userId);
      res.clearCookie("refreshToken");
      return res.status(200).json({
        message: "logout all success",
      });
    } catch (err: any) {
      return res.status(400).json({
        message: err.message,
      });
    }
  };

  refreshToken = async (req: Request, res: Response) => {
    try {
      const token = req.cookies.refreshToken;

      if (!token) {
        return res.status(401).json({
          message: "Refresh token missing",
        });
      }

      const result = await this.userService.refreshToken(token);

      return res.status(200).json({
        accessToken: result.accessToken,
      });
    } catch (err: any) {
      return res.status(401).json({
        message: err.message,
      });
    }
  };

  changePassword = async (req: Request, res: Response) => {
    try {
      const userId = req.user?.userId;

      if (!userId) {
        return res.status(401).json({
          message: "Unauthorized",
        });
      }

      const result = await this.userService.changePassword(userId, req.body);

      return res.status(200).json(result);
    } catch (err: any) {
      return res.status(400).json({
        message: err.message,
      });
    }
  };

  updateUser = async (req: Request, res: Response) => {
    try {
      const userId = req.user?.userId;

      if (!userId) {
        return res.status(401).json({
          message: "Unauthorized",
        });
      }

      const result = await this.userService.updateUser(userId, req.body);

      return res.status(200).json(result);
    } catch (err: any) {
      return res.status(400).json({
        message: err.message,
      });
    }
  };
}
