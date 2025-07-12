

interface Media {
  media_id: number
  url: string
}
interface Tag {
  tag_id: string
  name: string
}
interface Comment {
  comment_id: number
  post_id: string
  parent_comment_id: string | null
  user_id: string
  content: string
  comment_time: string
  like_count: number
  user: User
  medias: Media[]
  children:Comment[]
}
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