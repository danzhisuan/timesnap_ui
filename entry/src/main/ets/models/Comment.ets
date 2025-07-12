import { Media } from "./Media"
import { User } from "./User"


export interface  Comment {
  comment_id: string
  post_id: string
  content: string
  comment_time: string
  like_count: number
  user: User
  medias: Media[]
  children:Comment[]
}