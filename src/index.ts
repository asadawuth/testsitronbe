import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import morgan from "morgan";
import cookieParser from "cookie-parser";
import userRoutes from "./user/user.route";
import listMovieRoutes from "./listmovie/listmovie.route";
import { errorMiddleware } from "./middlewares/error.middleware";
import { notFoundMiddleware } from "./middlewares/notFound.middleware";
import { limiter } from "./middlewares/rateLimit";
dotenv.config({
  quiet: true,
});
const app = express();
const PORT = process.env.PORT || 3000;
app.use(cors());
app.use(express.json());
app.use(morgan("dev"));
app.use(cookieParser());
app.use(limiter);
app.use("/users", userRoutes);
app.use("/listmovie", listMovieRoutes);
app.get("/", (req, res) => {
  res.send("Check api is running");
});
app.use(notFoundMiddleware);
app.use(errorMiddleware);
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
