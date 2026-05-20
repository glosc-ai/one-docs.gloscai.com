import { defineConfig } from "vitepress";
import { withSidebar } from "vitepress-sidebar";

// https://vitepress.dev/reference/site-config
export default defineConfig(
    withSidebar(
        {
            title: "Glosc AI One Docs",
            description: "A VitePress Site",
            themeConfig: {
                // https://vitepress.dev/reference/default-theme-config
                nav: [
                    { text: "Home", link: "/" },
                    { text: "API", link: "/api/0.index" },
                    { text: "官网", link: "https://one.gloscai.com/" },
                ],

                socialLinks: [
                    {
                        icon: "github",
                        link: "https://github.com/glosc-ai/one-docs.gloscai.com",
                    },
                ],
            },
        },
        {
            documentRootPath: "/docs",
            scanStartPath: "/",
            basePath: "/",
            includeRootIndexFile: false,
            collapsed: false,
            useTitleFromFileHeading: true,
            useTitleFromFrontmatter: true,
        },
    ),
);
