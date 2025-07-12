import { User } from './User';

interface Chat {
  send_time: string;
  content: string;
  isImage?: boolean;
  sender: User;
  contact_id: string;
}