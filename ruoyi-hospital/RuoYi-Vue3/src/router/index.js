import { h, onMounted, ref } from 'vue'
import { createWebHistory, createRouter, useRouter } from 'vue-router'
/* Layout */
import Layout from '@/layout'
import useUserStore from '@/store/modules/user'
import useTagsViewStore from '@/store/modules/tagsView'
import { getToken } from '@/utils/auth'

const PortalRedirectView = {
  name: 'PortalRedirectView',
  setup() {
    const router = useRouter()
    const userStore = useUserStore()
    const isRedirecting = ref(false)

    function resolvePortalPath(roles) {
      if (roles?.includes('admin')) return '/medical/index'
      if (roles?.includes('doctor')) return '/medical-doctor/workbench'
      if (roles?.includes('common')) return '/medical-patient/home'
      return '/medical-patient/home'
    }

    async function redirectByRole() {
      if (isRedirecting.value) return
      isRedirecting.value = true

      const token = getToken()
      if (!token) {
        router.replace('/login')
        return
      }

      try {
        if (!Array.isArray(userStore.roles) || userStore.roles.length === 0) {
          await userStore.getInfo()
        }
        router.replace(resolvePortalPath(userStore.roles))
      } catch (e) {
        router.replace('/login')
      }
    }

    onMounted(() => redirectByRole())

    return () => h('div')
  }
}

/**
 * Note: 路由配置项
 *
 * hidden: true                     // 当设置 true 的时候该路由不会再侧边栏出现 如401，login等页面，或者如一些编辑页面/edit/1
 * alwaysShow: true                 // 当你一个路由下面的 children 声明的路由大于1个时，自动会变成嵌套的模式--如组件页面
 *                                  // 只有一个时，会将那个子路由当做根路由显示在侧边栏--如引导页面
 *                                  // 若你想不管路由下面的 children 声明的个数都显示你的根路由
 *                                  // 你可以设置 alwaysShow: true，这样它就会忽略之前定义的规则，一直显示根路由
 * redirect: noRedirect             // 当设置 noRedirect 的时候该路由在面包屑导航中不可被点击
 * name:'router-name'               // 设定路由的名字，一定要填写不然使用<keep-alive>时会出现各种问题
 * query: '{"id": 1, "name": "ry"}' // 访问路由的默认传递参数
 * roles: ['admin', 'common', 'doctor']       // 访问路由的角色权限 id 1 2 3
 * permissions: ['a:a:a', 'b:b:b']  // 访问路由的菜单权限
 * meta : {
    noCache: true                   // 如果设置为true，则不会被 <keep-alive> 缓存(默认 false)
    title: 'title'                  // 设置该路由在侧边栏和面包屑中展示的名字
    icon: 'svg-name'                // 设置该路由的图标，对应路径src/assets/icons/svg
    breadcrumb: false               // 如果设置为false，则不会在breadcrumb面包屑中显示
    activeMenu: '/system/user'      // 当路由设置了该属性，则会高亮相对应的侧边栏。
  }
 */

// 公共路由 (所有用户都可以访问)
export const constantRoutes = [
  {
    path: '/redirect',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/redirect/:path(.*)',
        component: () => import('@/views/redirect/index.vue')
      }
    ]
  },
  {
    path: '/login',
    component: () => import('@/views/login'),
    hidden: true
  },
  {
    path: '/register',
    component: () => import('@/views/register'),
    hidden: true
  },
  {
    path: '/',
    component: Layout,
    hidden: true,
    redirect: '/portal',
    children: [
      {
        path: 'portal',
        component: PortalRedirectView,
        name: 'Portal',
        meta: { title: '首页', affix: true }
      }
    ]
  },
  {
    path: '/user',
    component: Layout,
    hidden: true,
    redirect: 'noredirect',
    children: [
      {
        path: 'profile/:activeTab?',
        component: () => import('@/views/system/user/profile/index'),
        name: 'Profile',
        meta: { title: '个人中心', icon: 'user' }
      }
    ]
  }
]

// 动态路由，基于用户角色权限动态加载
export const dynamicRoutes = [
  // 管理端路由 (仅 admin 角色可访问)
  {
    path: '/medical',
    roles: ['admin'],
    component: Layout,
    hidden: false,
    redirect: '/medical/index',
    children: [
      {
        path: 'index',
        component: () => import('@/views/medical/index.vue'),
        name: 'MedicalIndex',
        meta: { title: '管理端 - 首页' }
      },
      {
        path: 'dashboard',
        component: () => import('@/views/medical/dashboard/index.vue'),
        name: 'MedicalDashboard',
        meta: { title: '数据大屏' }
      },
      {
        path: 'department',
        component: () => import('@/views/medical/department/index.vue'),
        name: 'MedicalDepartment',
        meta: { title: '科室管理' }
      },
      {
        path: 'doctor',
        component: () => import('@/views/medical/doctor/index.vue'),
        name: 'MedicalDoctor',
        meta: { title: '医生管理' }
      },
      {
        path: 'schedule',
        component: () => import('@/views/medical/schedule/index.vue'),
        name: 'MedicalSchedule',
        meta: { title: '号源管理' }
      },
      {
        path: 'appointment',
        component: () => import('@/views/medical/appointment/index.vue'),
        name: 'MedicalAppointment',
        meta: { title: '预约管理' }
      },
      {
        path: 'job',
        component: () => import('@/views/monitor/job/index.vue'),
        name: 'MonitorJob',
        meta: { title: '定时任务' }
      }
    ]
  },
  // 医生端路由 (仅 doctor 角色可访问)
  {
    path: '/medical-doctor',
    roles: ['doctor'],
    component: Layout,
    hidden: false,
    redirect: '/medical-doctor/workbench',
    children: [
      {
        path: 'workbench',
        component: () => import('@/views/medical-doctor/workbench/index.vue'),
        name: 'MedicalDoctorWorkbench',
        meta: { title: '医生端 - 工作台' }
      },
      {
        path: 'queue',
        component: () => import('@/views/medical-doctor/queue/index.vue'),
        name: 'MedicalDoctorQueue',
        meta: { title: '医生端 - 候诊队列' }
      },
      {
        path: 'consult',
        component: () => import('@/views/medical-doctor/consult/index.vue'),
        name: 'MedicalDoctorConsult',
        meta: { title: '医生端 - 接诊/病历' }
      },
      {
        path: 'schedule',
        component: () => import('@/views/medical-doctor/schedule/index.vue'),
        name: 'MedicalDoctorSchedule',
        meta: { title: '医生端 - 我的排班' }
      }
    ]
  },
  // 患者端路由 (仅 common 角色可访问)
  {
    path: '/medical-patient',
    roles: ['common'],
    component: () => import('@/layout/PatientLayout.vue'),
    hidden: false,
    redirect: '/medical-patient/home',
    children: [
      {
        path: 'home',
        component: () => import('@/views/medical-patient/home/index.vue'),
        name: 'MedicalPatientHome',
        meta: { title: '患者端 - 首页' }
      },
      {
        path: 'department',
        component: () => import('@/views/medical-patient/department/index.vue'),
        name: 'MedicalPatientDepartment',
        meta: { title: '患者端 - 科室' }
      },
      {
        path: 'doctor',
        component: () => import('@/views/medical-patient/doctor/index.vue'),
        redirect: '/medical-patient/doctor/list',
        children: [
          {
            path: 'list',
            component: () => import('@/views/medical-patient/doctor/list.vue'),
            name: 'MedicalPatientDoctorList',
            meta: { title: '患者端 - 医生列表' }
          },
          {
            path: 'detail/:doctorId(\\d+)',
            component: () => import('@/views/medical-patient/doctor/detail.vue'),
            name: 'MedicalPatientDoctorDetail',
            meta: { title: '患者端 - 医生详情' }
          }
        ]
      },
      {
        path: 'schedule',
        component: () => import('@/views/medical-patient/schedule/index.vue'),
        name: 'MedicalPatientSchedule',
        meta: { title: '患者端 - 排班' }
      },
      {
        path: 'appointment',
        component: () => import('@/views/medical-patient/appointment/index.vue'),
        redirect: '/medical-patient/appointment/confirm',
        children: [
          {
            path: 'confirm',
            component: () => import('@/views/medical-patient/appointment/confirm.vue'),
            name: 'MedicalPatientAppointmentConfirm',
            meta: { title: '患者端 - 确认预约' }
          },
          {
            path: 'success',
            component: () => import('@/views/medical-patient/appointment/success.vue'),
            name: 'MedicalPatientAppointmentSuccess',
            meta: { title: '患者端 - 预约成功' }
          }
        ]
      },
      {
        path: 'order',
        redirect: '/medical-patient/order/list',
        children: [
          {
            path: 'list',
            component: () => import('@/views/medical-patient/order/list.vue'),
            name: 'MedicalPatientOrderList',
            meta: { title: '患者端 - 我的预约' }
          }
        ]
      },
      {
        path: 'profile',
        component: () => import('@/views/medical-patient/profile/index.vue'),
        name: 'MedicalPatientProfile',
        meta: { title: '患者端 - 个人中心' }
      }
    ]
  },
  // 系统功能路由 (基于菜单权限)
  {
    path: '/system/user-auth',
    component: Layout,
    hidden: true,
    permissions: ['system:user:edit'],
    children: [
      {
        path: 'role/:userId(\\d+)',
        component: () => import('@/views/system/user/authRole'),
        name: 'AuthRole',
        meta: { title: '分配角色', activeMenu: '/system/user' }
      }
    ]
  },
  {
    path: '/system/role-auth',
    component: Layout,
    hidden: true,
    permissions: ['system:role:edit'],
    children: [
      {
        path: 'user/:roleId(\\d+)',
        component: () => import('@/views/system/role/authUser'),
        name: 'AuthUser',
        meta: { title: '分配用户', activeMenu: '/system/role' }
      }
    ]
  },
  {
    path: '/system/dict-data',
    component: Layout,
    hidden: true,
    permissions: ['system:dict:list'],
    children: [
      {
        path: 'index/:dictId(\\d+)',
        component: () => import('@/views/system/dict/data'),
        name: 'Data',
        meta: { title: '字典数据', activeMenu: '/system/dict' }
      }
    ]
  },
  {
    path: '/monitor/job-log',
    component: Layout,
    hidden: true,
    permissions: ['monitor:job:list'],
    children: [
      {
        path: 'index/:jobId(\\d+)',
        component: () => import('@/views/monitor/job/log'),
        name: 'JobLog',
        meta: { title: '调度日志', activeMenu: '/monitor/job' }
      }
    ]
  },
  {
    path: '/tool/gen-edit',
    component: Layout,
    hidden: true,
    permissions: ['tool:gen:edit'],
    children: [
      {
        path: 'index/:tableId(\\d+)',
        component: () => import('@/views/tool/gen/editTable'),
        name: 'GenEdit',
        meta: { title: '修改生成配置', activeMenu: '/tool/gen' }
      }
    ]
  }
]

export const notFoundRoute = {
  path: '/:pathMatch(.*)*',
  component: Layout,
  hidden: true,
  children: [
    {
      path: '',
      component: () => import('@/views/error/404.vue'),
      name: 'NotFound',
      meta: { title: '404', icon: 'error' }
    }
  ]
}

// 所有路由 (包含动态路由，用于支持 URL直接访问)
const allRoutes = constantRoutes.concat([
  ...dynamicRoutes,
  notFoundRoute
])

const router = createRouter({
  history: createWebHistory(),
  routes: allRoutes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    }
    return { top: 0 }
  },
})

export default router
