export interface  LikeStats {
  is_liked: boolean //是否点赞
  like_count: number //点赞数
}

export interface  CollectStats {
  is_collected: boolean //是否收藏
  collect_count: number //收藏数
}

export interface FollowStats{
  follower_count:number //关注人数
  followee_count:number //粉丝人数
}