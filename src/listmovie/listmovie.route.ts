import express from "express";
import { ListMovieService } from "./listmovie.service";
import { ListMovieController } from "./listmovie.controller";
const router = express.Router();
const listMovieService = new ListMovieService();
const listMovieController = new ListMovieController(listMovieService);
import { validate } from "../middlewares/createError";

import { authMiddleware } from "../middlewares/auth.middleware";
import { createMovieSchema, updateMovieSchema } from "./listmovie.dto";

router.post(
  "/createdmovie",
  authMiddleware,
  validate(createMovieSchema),
  listMovieController.createdMovie,
);
router.get("/getlistmovie", authMiddleware, listMovieController.getListMovie);
router.patch(
  "/editslistmovie/:id",
  authMiddleware,
  validate(updateMovieSchema),
  listMovieController.editsListMovie,
);
router.delete(
  "/deletelistmovie",
  authMiddleware,
  listMovieController.deleteListMovie,
);
export default router;
