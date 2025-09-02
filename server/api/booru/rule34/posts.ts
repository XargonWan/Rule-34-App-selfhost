export default defineEventHandler(async (event) => {
  const query = getQuery(event)

  // Only proxy if baseEndpoint is rule34.xxx
  if (query.baseEndpoint !== 'rule34.xxx') {
    return {
      data: {},
      message: 'File not found.',
      status: 404
    }
  }

  // Map frontend params to rule34.xxx API
  const params = new URLSearchParams()
  params.set('page', 'dapi')
  params.set('s', 'post')
  params.set('q', 'index')
  params.set('json', '1')

  if (query.limit) params.set('limit', query.limit as string)
  if (query.pageID) params.set('pid', query.pageID as string)
  if (query.tags) params.set('tags', query.tags as string)
  if (query.id) params.set('id', query.id as string)
  // Add other custom params if needed

  // Build final API URL
  const apiUrl = `https://api.rule34.xxx/index.php?${params.toString()}`

  // Manual fetch and return JSON
  const res = await fetch(apiUrl)
  const json = await res.json()
  return json
})
