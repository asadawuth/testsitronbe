import { z } from "zod";
import { user_role } from "@prisma/client";

export interface registerAdminDto {
  id: number;
  first_name: string;
  last_name: string;
  email: string;
  password: string;
  tel: string;
  role: user_role;
  created_at: Date;
}

export const createUserSchema = z.object({
  first_name: z
    .string({ message: "กรุณากรอกชื่อ" })
    .max(60, "ชื่อต้องไม่เกิน 60 ตัวอักษร")
    .regex(/^[A-Za-zก-๙]+$/, "ชื่อห้ามมีตัวเลขหรืออักขระพิเศษ"),

  last_name: z
    .string()
    .max(60, "นามสกุลต้องไม่เกิน 60 ตัวอักษร")
    .regex(/^[A-Za-zก-๙]+$/, "นามสกุลห้ามมีตัวเลขหรืออักขระพิเศษ")
    .optional(),

  email: z.string({ message: "กรุณากรอกอีเมล" }).email("รูปแบบอีเมลไม่ถูกต้อง"),

  password: z
    .string({ message: "กรุณากรอกรหัสผ่าน" })
    .min(8, "รหัสผ่านต้องมีอย่างน้อย 8 ตัว")
    .max(12, "รหัสผ่านต้องไม่เกิน 12 ตัว")
    .regex(/[A-Z]/, "ต้องมีตัวพิมพ์ใหญ่ A-Z อย่างน้อย 1 ตัว")
    .regex(/[a-z]/, "ต้องมีตัวพิมพ์เล็ก a-z อย่างน้อย 1 ตัว")
    .regex(/[0-9]/, "ต้องมีตัวเลข 0-9 อย่างน้อย 1 ตัว")
    .regex(/[^A-Za-z0-9]/, "ต้องมีอักขระพิเศษอย่างน้อย 1 ตัว"),

  tel: z
    .string()
    .length(10, "เบอร์โทรต้อง 10 หลักเท่านั้น")
    .regex(/^[0-9]+$/, "เบอร์โทรต้องเป็นตัวเลขเท่านั้น"),

  role: z
    .nativeEnum(user_role, {
      message: "role ต้องเป็น MANAGER | TEAMLEADER | FLOORSTAFF",
    })
    .optional(),
});

export const loginSchema = z.object({
  identifier: z.string({
    message: "กรุณากรอก email หรือ เบอร์โทร",
  }),
  password: z.string({
    message: "กรุณากรอกรหัสผ่าน",
  }),
});

export const changePasswordSchema = z
  .object({
    oldPassword: z.string().min(8, "รหัสผ่านเก่าต้องอย่างน้อย 8 ตัว"),

    newPassword: z
      .string()
      .min(8, "รหัสผ่านใหม่ต้องอย่างน้อย 8 ตัว")
      .max(12, "รหัสผ่านใหม่ต้องไม่เกิน 12 ตัว")
      .regex(/[A-Z]/, "ต้องมีตัวพิมพ์ใหญ่ A-Z อย่างน้อย 1 ตัว")
      .regex(/[a-z]/, "ต้องมีตัวพิมพ์เล็ก a-z อย่างน้อย 1 ตัว")
      .regex(/[0-9]/, "ต้องมีตัวเลขอย่างน้อย 1 ตัว")
      .regex(/[^A-Za-z0-9]/, "ต้องมีอักขระพิเศษอย่างน้อย 1 ตัว"),

    confirmPassword: z.string(),
  })
  .refine((data) => data.newPassword === data.confirmPassword, {
    message: "ยืนยันรหัสผ่านใหม่ไม่ตรงกัน",
    path: ["confirmPassword"],
  });

export const updateUserSchema = z.object({
  first_name: z
    .string()
    .max(60, "ชื่อต้องไม่เกิน 60 ตัว")
    .regex(/^[A-Za-zก-๙]+$/, "ชื่อห้ามมีตัวเลข")
    .optional(),

  last_name: z
    .string()
    .max(60, "นามสกุลต้องไม่เกิน 60 ตัว")
    .regex(/^[A-Za-zก-๙]+$/, "นามสกุลห้ามมีตัวเลข")
    .optional(),

  tel: z
    .string()
    .length(10, "เบอร์โทรต้อง 10 หลัก")
    .regex(/^[0-9]+$/, "เบอร์ต้องเป็นตัวเลข")
    .optional(),

  email: z.string().email("รูปแบบอีเมลไม่ถูกต้อง").optional(),
});

export type UpdateUserDto = z.infer<typeof updateUserSchema>;
