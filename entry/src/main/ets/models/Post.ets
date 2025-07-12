import { Comment } from './Comment'
import { Media } from './Media'
import { Tag } from './Tag'
import { User } from './User'

interface Post {
  post_id: number
  publish_time: string
  title: string
  content: string
}
interface Permission {
  view_permission: string
  comment_permission: string
}
interface Stats {
  like_count: number
  collect_count: number
  browse_count: number
  comment_count: number
  isLiked: boolean
  isCollected: boolean
}
interface PostDetail {
  post: Post
  user: User
  permission: Permission
  stats: Stats
  medias: Media[]
  tags: Tag[]
  comments: Comment[]
}