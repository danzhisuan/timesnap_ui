import { Media } from "./Media"
import { LikeStats } from "./Stats"
import { User } from "./User"


export interface  Comment {
  comment_id: string
  post_id: string
  content: string
  comment_time: string
  like_stats:LikeStats
  commenter: User
  medias: Media[]
  children:Comment[]
}