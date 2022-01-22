import { Link, useLoaderData } from "remix";
import { PrismicClient } from "~/prismic-client";
import { PrismicRichText } from '@prismicio/react'

export const loader = async() => {
  const prismicDoc = await PrismicClient.getFirst()
  return { title, content } = prismicDoc.data
};

export default function Index() {
  const {title, content} = useLoaderData();
  return (
    <div style={{ fontFamily: "system-ui, sans-serif", lineHeight: "1.4" }}>
      <PrismicRichText field={title} />
      <PrismicRichText field={content} />
    </div>
  );
}
