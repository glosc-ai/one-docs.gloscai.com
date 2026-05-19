import type { Theme } from "vitepress";
import type { Zoom } from "medium-zoom";
import DefaultTheme from "vitepress/theme";
import { useRoute } from "vitepress";
import { nextTick, onMounted, watch } from "vue";
import "./custom.css";

let zoom: Zoom | null = null;

async function updateMediumZoom() {
    const { default: mediumZoom } = await import("medium-zoom");

    zoom?.detach();
    zoom = mediumZoom(".vp-doc img:not(.no-zoom)", {
        background: "var(--vp-c-bg)",
        margin: 24,
    });
}

export default {
    extends: DefaultTheme,
    setup() {
        const route = useRoute();

        const applyZoom = () => {
            void nextTick(() => {
                void updateMediumZoom();
            });
        };

        onMounted(applyZoom);
        watch(() => route.path, applyZoom);
    },
} satisfies Theme;
