export interface MovieHistoryData {
  title: string;
  release_year: string;
  type_movie: string;
  image_url: string | null;
  rate: number | null;
  created_at?: string;
}

export interface HistoryUser {
  first_name: string;
  last_name: string;
  role: string;
}

export interface HistoryItem {
  id: number;
  user_id: number | null;
  users: HistoryUser | null;
  movie_id: number | null;
  action: string;
  old_data: MovieHistoryData | null;
  new_data: MovieHistoryData | null;
  created_at: Date;
}

export interface Pagination {
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

export interface HistoryResponse {
  message: string;
  pagination: Pagination;
  data: HistoryItem[];
}
