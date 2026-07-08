import type { APIContext } from "astro";
import rss from "@astrojs/rss";
import { getCollection } from "astro:content";

export async function GET(context: APIContext) {
  const blog = await getCollection("blog", ({ data }) => !data.draft);

  return rss({
    title: "Nicole Thalia Heinimann's Blog",
    description:
      "Blog posts from Nicole Thalia Heinimann - PhD Student at TU Berlin",
    site: context.site!,
    items: blog
      .sort((a, b) => b.data.date.valueOf() - a.data.date.valueOf())
      .map((post) => ({
        title: post.data.title,
        pubDate: post.data.date,
        description: post.data.description,
        link: `/blog/${post.id}/`,
      })),
  });
}
