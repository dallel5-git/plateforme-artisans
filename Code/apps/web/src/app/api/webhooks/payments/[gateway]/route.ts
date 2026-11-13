export async function POST(
  _request: Request,
  { params }: { params: Promise<{ gateway: string }> },
) {
  const { gateway } = await params;
  return Response.json({
    received: true,
    gateway,
    timestamp: new Date().toISOString(),
  });
}
