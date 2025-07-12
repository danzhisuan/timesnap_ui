export interface  LikeStats {
  is_liked: boolean
  like_count: number
}

export interface  CollectStats {
  collect_count: number
  is_collected: boolean
}

export interface FollowStats{
  follower_count:number //关注人数
  followee_count:number //粉丝人数
}