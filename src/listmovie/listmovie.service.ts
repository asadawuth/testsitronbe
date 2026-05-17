import { Prisma, movie_rating } from "@prisma/client";
import { prisma } from "../model/prisma";
import { CreateMovieDto } from "./listmovie.dto";
import { getPagination, paginationMeta } from "../utils/pagination";
import { UpdateMovieDto } from "./listmovie.dto";

export class ListMovieService {
  async createdMovie(userId: number, data: CreateMovieDto) {
    const movie = await prisma.movies.create({
      data: {
        user_admin: userId,
        title: data.title,
        release_year: data.release_year,
        type_movie: data.type_movie,
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
    type_movie?: movie_rating,
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

    const total = await prisma.movies.count({
      where: whereCondition,
    });

    const movies = await prisma.movies.findMany({
      where: whereCondition,
      skip,
      take: currentLimit,
      orderBy: {
        created_at: "desc",
      },
      include: {
        users: {
          select: {
            id: true,
            first_name: true,
            email: true,
          },
        },
      },
    });

    return {
      message: "list movies retrieved successfully",
      pagination: paginationMeta(total, currentPage, currentLimit),
      data: movies,
    };
  }

  async editsListMovie(movieId: number, userId: number, data: UpdateMovieDto) {
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
      data,
    });

    return {
      message: "Edit movie successfully",
      movie: updatedMovie,
    };
  }

  async deleteListMovie() {
    return {
      message: "delete movie pending...",
    };
  }
}
