import { user_role } from "@prisma/client";

export type User = {
  id: number;
  name: string;
  email: string;
  password: string;
  role: "MANAGER" | "TEAMLEADER" | "FLOORSTAFF";
};

export interface LoginResponse {
  accessToken: string;
  refreshToken: string;
  user: {
    id: number;
    first_name: string;
    last_name: string;
    email: string;
    tel: string;
    role: user_role;
  };

  session?: {
    device: string;
    ipAddress: string;
  };
}

export interface RegisterResponse {
  data: {
    id: number;
    email: string;
    first_name: string;
    last_name: string;
    role: user_role;
  };
}

export interface ChangePasswordDto {
  oldPassword: string;
  newPassword: string;
  confirmPassword: string;
}
