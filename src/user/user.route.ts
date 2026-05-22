import express from "express";
import { UserController } from "./user.controller";
import { UserService } from "./user.service";
import {
  createUserSchema,
  loginSchema,
  changePasswordSchema,
  updateUserSchema,
} from "./user.dto";
import { validate } from "../middlewares/createError";
import { authMiddleware } from "../middlewares/auth.middleware";

const router = express.Router();
const userService = new UserService();
const userController = new UserController(userService);

router.post("/register", validate(createUserSchema), userController.register);
router.post("/login", validate(loginSchema), userController.login);
router.post("/logout", authMiddleware, userController.logout);
router.post("/logoutall", authMiddleware, userController.logoutAll);
router.post("/refresh", userController.refreshToken);
router.patch(
  "/changepassword",
  authMiddleware,
  validate(changePasswordSchema),
  userController.changePassword
);
router.patch(
  "/updatesuser",
  authMiddleware,
  validate(updateUserSchema),
  userController.updateUser
);
router.get("/userststem", authMiddleware, userController.userSystem);
export default router;
