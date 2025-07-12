export interface LoginRequest{ //登录请求
  email : string;
  password : string;
}

export interface LoginResponse{ //登录返回
  access_token : string;
  user_id : number;
}