// 处理各种权限认证服务

import { preferences } from '@kit.ArkData';
import { ApiService } from '../services/api.service';
import { LoginRequest, LoginResponse } from '../models/Login';
import { Context } from '@kit.AbilityKit'; // 获取当前 context


export class AuthService {
  private apiService = new ApiService();
  private static readonly PREFS_NAME = 'dataStore'; //存储库名

  // 获取 Preferences 实例
  private static getPrefs(context: Context): preferences.Preferences {
    return preferences.getPreferencesSync(context, { name: AuthService.PREFS_NAME });
  }

  // 登录方法，返回登录响应数据
  async login(email: string, password: string): Promise<LoginResponse> {
    const loginRequest: LoginRequest = {
      email,
      password,
    };
    try {
      //获取token和id
      const response = await this.apiService.post<LoginRequest, LoginResponse>(
        'auth/login',
        loginRequest,
      );

      const context = getContext(this); //获取上下文
      await this.saveLoginInfo(context,response);//存储 持久化

      return response;
    } catch (err) {
      console.error('登录失败:', err);
      // 如果 err 不是 Error 实例，包装一下
      if (err instanceof Error) {
        throw err;
      } else {
        throw new Error(typeof err === 'string' ? err : 'Unknown error');
      }
    }
  }

  //保存登录信息持久化
  async saveLoginInfo(context : Context, loginResponse : LoginResponse){
    const prefs = AuthService.getPrefs(context);//获取实例

    prefs.putSync('access_token',loginResponse.access_token);
    prefs.putSync('user_id',loginResponse.user_id);

    prefs.flush((err) => {
      if (err) {
        console.error(`🔴 flush失败: ${err.code} - ${err.message}`);
      } else {
        console.info('✅ 登录信息已持久化保存');
      }
    });
  }

  //获取Token
  static getToken(context: Context): string {
    const prefs = AuthService.getPrefs(context);
    return prefs.getSync('access_token', '') as string;
  }

  //获取用户Id
  static getUserId(context: Context): string {
    const prefs = AuthService.getPrefs(context);
    return prefs.getSync('user_id', '') as string;
  }

  //清除登录信息
  static clearLoginInfo(context: Context): void {
    const prefs = AuthService.getPrefs(context);
    prefs.deleteSync('access_token');
    prefs.deleteSync('user_id');
    prefs.flush((err) => {
      if (err) {
        console.error(`清除失败: ${err.code}, ${err.message}`);
      } else {
        console.info('登录信息已清除');
      }
    });
  }


}
