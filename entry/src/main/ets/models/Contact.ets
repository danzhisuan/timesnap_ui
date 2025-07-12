import { User } from './User';

export interface  Contact {
  friend: User;
  latest_message: string;
  contact_id: string;
}