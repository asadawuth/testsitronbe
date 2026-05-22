import type { Request, Response } from "express";
import { ListMovieService } from "./listmovie.service";
import { movie_rating } from "@prisma/client";
export class ListMovieController {
  constructor(private readonly listMovieService: ListMovieService) {}

  createdMovie = async (req: Request, res: Response) => {
    try {
      const userId = req.user?.userId;

      if (!userId) {
        return res.status(401).json({
          message: "Unauthorized",
        });
      }
      const file = req.file;
      const imageUrl = file ? `/public/movies/${file.filename}` : null;
      const result = await this.listMovieService.createdMovie(userId, {
        ...req.body,
        image_url: imageUrl,
      });

      return res.status(200).json(result);
    } catch (err: any) {
      return res.status(400).json({
        message: err.message,
      });
    }
  };

  getListMovie = async (req: Request, res: Response) => {
    try {
      const page = Number(req.query.page) || 1;
      const limit = Number(req.query.limit) || 10;
      const search = req.query.search as string;
      const type_movie = req.query.type_movie as movie_rating;
      const result = await this.listMovieService.getListMovie(
        page,
        limit,
        search,
        type_movie
      );
      return res.status(200).json(result);
    } catch (err: any) {
      return res.status(400).json({
        message: err.message,
      });
    }
  };

  editsListMovie = async (req: Request, res: Response) => {
    try {
      const movieId = Number(req.params.id);
      const userId = req.user?.userId;
      if (!userId) {
        return res.status(401).json({
          message: "Unauthorized",
        });
      }
      const result = await this.listMovieService.editsListMovie(
        movieId,
        userId,
        req.body,
        req.file
      );
      return res.status(200).json(result);
    } catch (err: any) {
      return res.status(400).json({
        message: err.message,
      });
    }
  };

  deleteListMovie = async (req: Request, res: Response) => {
    try {
      const movieId = Number(req.params.id);
      const user = req.user;

      if (!user) {
        return res.status(401).json({
          message: "Unauthorized",
        });
      }
      const result = await this.listMovieService.deleteListMovie(
        movieId,
        user.userId,
        user.role
      );

      return res.json(result);
    } catch (err: any) {
      return res.status(400).json({
        message: err.message,
      });
    }
  };

  history = async (req: Request, res: Response) => {
    try {
      const page = Number(req.query.page) || 1;
      const limit = Number(req.query.limit) || 10;
      const result = await this.listMovieService.history(page, limit);
      return res.status(200).json(result);
    } catch (err: any) {
      return res.status(400).json({
        message: err.message,
      });
    }
  };
}
