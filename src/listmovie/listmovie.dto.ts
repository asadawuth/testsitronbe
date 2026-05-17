import { z } from "zod";
import { movie_rating } from "@prisma/client";

export const createMovieSchema = z.object({
  title: z
    .string()
    .min(1, "กรุณากรอกชื่อหนัง")
    .max(200, "ชื่อหนังต้องไม่เกิน 200 ตัวอักษร"),

  release_year: z
    .string()
    .length(4, "ปีต้องมี 4 หลัก")
    .regex(/^\d+$/, "ปีต้องเป็นตัวเลขเท่านั้น"),

  type_movie: z.nativeEnum(movie_rating, {
    message: "type_movie ต้องเป็น G | PG | M | MA | R",
  }),
});

export type CreateMovieDto = z.infer<typeof createMovieSchema>;

export const updateMovieSchema = z.object({
  title: z
    .string()
    .min(1, "กรุณากรอกชื่อหนัง")
    .max(200, "ชื่อหนังต้องไม่เกิน 200 ตัว")
    .optional(),

  release_year: z
    .string()
    .length(4, "ปีต้องมี 4 หลัก")
    .regex(/^\d+$/, "ปีต้องเป็นตัวเลข")
    .optional(),

  type_movie: z
    .nativeEnum(movie_rating, {
      message: "type_movie ต้องเป็น G | PG | M | MA | R",
    })
    .optional(),
});

export type UpdateMovieDto = z.infer<typeof updateMovieSchema>;
