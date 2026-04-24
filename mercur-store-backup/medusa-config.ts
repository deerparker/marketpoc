import { defineConfig, loadEnv } from '@medusajs/framework/utils'

loadEnv(process.env.NODE_ENV || 'development', process.cwd())

module.exports = defineConfig({
    projectConfig: {
        databaseUrl: process.env.DATABASE_URL,
        http: {
            storeCors: process.env.STORE_CORS!,
            adminCors: process.env.ADMIN_CORS!,
            authCors: process.env.AUTH_CORS!,
            vendorCors: process.env.VENDOR_CORS!,  // MercurJS-specific property
            jwtSecret: process.env.JWT_SECRET || 'supersecret',
            cookieSecret: process.env.COOKIE_SECRET || 'supersecret'
        } as any,  // Type assertion needed for MercurJS-specific vendorCors
    },
    admin: {
        vite: (config) => {
            config.define = {
                ...config.define,
                __AUTH_TYPE__: JSON.stringify("cookie"),
                __BASE__: JSON.stringify("/app"),
                __JWT_TOKEN_STORAGE_KEY__: JSON.stringify("medusa_admin_jwt"),
                __COOKIE_KEY__: JSON.stringify("medusa_admin_cookie"),
                __BACKEND_URL__: JSON.stringify("http://localhost:9000"),
                __MEDUSA_BACKEND_URL__: JSON.stringify("http://localhost:9000"),
            }
            return config
        }
    },
    plugins: [
        {
            resolve: '@mercurjs/b2c-core',
            options: {
                enable_seller_registration: true
            }
        },
        {
            resolve: '@mercurjs/commission',
            options: {}
        },
        {
            resolve: '@mercurjs/algolia',
            options: {
                apiKey: process.env.ALGOLIA_API_KEY,
                appId: process.env.ALGOLIA_APP_ID
            }
        },
        {
            resolve: '@mercurjs/reviews',
            options: {}
        },
        {
            resolve: '@mercurjs/requests',
            options: {}
        },
        {
            resolve: '@mercurjs/resend',
            options: {}
        }
    ],
    modules: [
        {
            resolve: '@medusajs/medusa/payment',
            options: {
                providers: [
                    {
                        resolve: '@mercurjs/payment-stripe-connect/providers/stripe-connect',
                        id: 'stripe-connect',
                        options: {
                            apiKey: process.env.STRIPE_SECRET_API_KEY
                        }
                    }
                ]
            }
        },
        {
            resolve: '@medusajs/medusa/notification',
            options: {
                providers: [
                    {
                        resolve: '@mercurjs/resend/providers/resend',
                        id: 'resend',
                        options: {
                            channels: ['email'],
                            api_key: process.env.RESEND_API_KEY,
                            from: process.env.RESEND_FROM_EMAIL
                        }
                    },
                    {
                        resolve: '@medusajs/medusa/notification-local',
                        id: 'local',
                        options: {
                            channels: ['feed', 'seller_feed']
                        }
                    }
                ]
            }
        }
    ]
})
