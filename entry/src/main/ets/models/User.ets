import { FollowStats, LikeStats } from "./Stats";

export interface  User { //用户信息
  user_id: string;
  avatar_url: string;
  nickname: string;
  email: string;
  is_followed:boolean;
};

export interface UserDetail {
  user:User
  introduction: string
  follow_stats: FollowStats
  like_count: number
  collect_count: number
}