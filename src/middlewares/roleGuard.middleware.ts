import { Request, Response, NextFunction } from "express";
import { user_role } from "@prisma/client";

export const roleGuard = (roles: user_role[]) => {
  return (req: Request, res: Response, next: NextFunction) => {
    const user = req.user;

    if (!user) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    if (!roles.includes(user.role)) {
      return res.status(403).json({
        message: "MANAGER",
      });
    }

    next();
  };
};
