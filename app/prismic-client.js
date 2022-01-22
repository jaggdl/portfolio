import * as prismic from '@prismicio/client';

const repoName = 'jaggdl';
const endpoint = prismic.getEndpoint(repoName);

export const PrismicClient = prismic.createClient(endpoint);