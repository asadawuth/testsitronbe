import express from "express";
import { ListMovieService } from "./listmovie.service";
import { ListMovieController } from "./listmovie.controller";
const router = express.Router();
const listMovieService = new ListMovieService();
const listMovieController = new ListMovieController(listMovieService);
import { validate } from "../middlewares/createError";
import { authMiddleware } from "../middlewares/auth.middleware";
import { createMovieSchema, updateMovieSchema } from "./listmovie.dto";
import { roleGuard } from "../middlewares/roleGuard.middleware";
import { upload } from "../middlewares/upload";

router.post(
  "/createdmovie",
  authMiddleware,
  upload.single("image"),
  validate(createMovieSchema),
  listMovieController.createdMovie
);
router.get("/getlistmovie", authMiddleware, listMovieController.getListMovie);
router.patch(
  "/editslistmovie/:id",
  authMiddleware,
  upload.single("image"),
  validate(updateMovieSchema),
  listMovieController.editsListMovie
);
router.delete(
  "/deletelistmovie/:id",
  authMiddleware,
  roleGuard(["MANAGER"]),
  listMovieController.deleteListMovie
);
router.get("/history", authMiddleware, listMovieController.history);
export default router;
