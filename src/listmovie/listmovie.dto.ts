import { z } from "zod";
import { movie_rating } from "@prisma/client";

export const createMovieSchema = z.object({
  title: z.string().min(1),

  release_year: z.string().length(4).regex(/^\d+$/),

  type_movie: z.nativeEnum(movie_rating),

  rate: z.coerce.number().min(1).max(100),

  image_url: z.string().optional().nullable(),
});

export type CreateMovieDto = z.infer<typeof createMovieSchema>;

export const updateMovieSchema = z.object({
  title: z.string().min(1).max(200).optional(),

  release_year: z.string().length(4).regex(/^\d+$/).optional(),

  type_movie: z.nativeEnum(movie_rating).optional(),

  rate: z.coerce.number().min(1).max(100).optional(),

  image_url: z.string().optional().nullable(),
});

export type UpdateMovieDto = z.infer<typeof updateMovieSchema>;

export type DeleteMovieDto = {
  movieId: number;
};
