export async function POST() {
  return Response.json({
    url: 'https://storage.sanaya.tn/uploads/mock',
    fields: { key: `upload-${Date.now()}` },
  });
}
