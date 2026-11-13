export async function POST(_request: Request) {
  return Response.json({
    url: 'https://storage.sanaya.tn/uploads/mock',
    fields: { key: `upload-${Date.now()}` },
  });
}
