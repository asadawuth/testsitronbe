import { Prisma, movie_rating, user_role } from "@prisma/client";
import fs from "fs";
import path from "path";
import { prisma } from "../model/prisma";
import { CreateMovieDto } from "./listmovie.dto";
import { getPagination, paginationMeta } from "../utils/pagination";
import { UpdateMovieDto } from "./listmovie.dto";
import { HistoryResponse, MovieHistoryData } from "./listmovietype";

export class ListMovieService {
  async createdMovie(userId: number, data: CreateMovieDto) {
    const movie = await prisma.movies.create({
      data: {
        user_admin: userId,
        title: data.title,
        release_year: data.release_year,
        type_movie: data.type_movie,
        rate: data.rate,
        image_url: data.image_url,
      },
    });

    return {
      message: "Movie created successfully",
      movie,
    };
  }

  async getListMovie(
    page: number,
    limit: number,
    search?: string,
    type_movie?: movie_rating
  ) {
    const {
      skip,
      page: currentPage,
      limit: currentLimit,
    } = getPagination(page, limit);

    const whereCondition: Prisma.moviesWhereInput = {};

    if (search) {
      whereCondition.title = {
        contains: search,
        mode: "insensitive",
      };
    }

    if (type_movie) {
      whereCondition.type_movie = type_movie;
    }

    const [total, movies] = await Promise.all([
      prisma.movies.count({ where: whereCondition }),

      prisma.movies.findMany({
        where: whereCondition,
        skip,
        take: currentLimit,
        orderBy: {
          created_at: "desc",
        },
      }),
    ]);

    return {
      message: "list movies retrieved successfully",
      pagination: paginationMeta(total, currentPage, currentLimit),
      data: movies,
    };
  }

  async editsListMovie(
    movieId: number,
    userId: number,
    data: UpdateMovieDto,
    file?: Express.Multer.File
  ) {
    const movie = await prisma.movies.findUnique({
      where: {
        id: movieId,
      },
    });
    if (!movie) {
      throw new Error("ไม่พบหนัง");
    }
    if (movie.user_admin !== userId) {
      throw new Error("คุณไม่มีสิทธิ์แก้ไขหนังนี้");
    }
    const updatedMovie = await prisma.movies.update({
      where: {
        id: movieId,
      },
      data: {
        ...data,

        image_url: file ? `/public/movies/${file.filename}` : movie.image_url,
      },
    });
    await prisma.history.create({
      data: {
        user_id: userId,
        movie_id: movieId,
        action: "EDIT",
        old_data: {
          title: movie.title,
          release_year: movie.release_year,
          type_movie: movie.type_movie,
          image_url: movie.image_url,
          rate: movie.rate,
          created_at: movie.created_at,
        },
        new_data: {
          title: updatedMovie.title,
          release_year: updatedMovie.release_year,
          type_movie: updatedMovie.type_movie,
          image_url: updatedMovie.image_url,
          rate: updatedMovie.rate,
          created_at: updatedMovie.created_at,
        },
      },
    });
    return {
      message: "Edit movie successfully",
      movie: updatedMovie,
    };
  }

  async deleteListMovie(movieId: number, userId: number, role: user_role) {
    if (role !== "MANAGER") {
      throw new Error("Can only delete movie with MANAGER role");
    }
    const movie = await prisma.movies.findUnique({
      where: { id: movieId },
    });
    if (!movie) {
      throw new Error("Movie not found");
    }
    if (movie.image_url) {
      const filePath = path.join(__dirname, "../../", movie.image_url);
      fs.unlink(filePath, (err) => {
        if (err) {
          console.log("Delete image error:", err.message);
        }
      });
    }
    await prisma.movies.delete({
      where: { id: movieId },
    });
    return {
      message: "Movie deleted successfully",
    };
  }

  async history(page: number, limit: number): Promise<HistoryResponse> {
    const {
      skip,
      page: currentPage,
      limit: currentLimit,
    } = getPagination(page, limit);

    const [total, histories] = await Promise.all([
      prisma.history.count(),
      prisma.history.findMany({
        skip,
        take: currentLimit,
        orderBy: {
          created_at: "desc",
        },
        select: {
          id: true,
          user_id: true,
          users: {
            select: {
              first_name: true,
              last_name: true,
              role: true,
            },
          },
          movie_id: true,
          action: true,
          old_data: true,
          new_data: true,
          created_at: true,
        },
      }),
    ]);

    return {
      message: "history retrieved successfully",
      pagination: paginationMeta(total, currentPage, currentLimit),
      data: histories.map((item) => {
        const oldData = item.old_data as MovieHistoryData | null;
        const newData = item.new_data as MovieHistoryData | null;
        if (oldData?.created_at) {
          delete (oldData as any).created_at;
        }
        if (newData?.created_at) {
          delete (newData as any).created_at;
        }
        return {
          ...item,
          old_data: oldData,
          new_data: newData,
        };
      }),
    };
  }
}
