import { FollowStats, LikeStats } from "./Stats";

export interface  UserSimple { //用户信息
  user_id: number;
  avatar: string;
  nickname: string;
  email: string;
  is_followed:boolean;
};

export interface UserDetail { //用户详细页
  user_simple:UserSimple
  introduction: string
  follow_stats: FollowStats
  like_count: number
  collect_count: number
}