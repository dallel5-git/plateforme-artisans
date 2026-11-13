export async function GET(
  _request: Request,
  { params }: { params: Promise<{ job: string }> },
) {
  const { job } = await params;
  return Response.json({
    status: 'ok',
    job,
    executedAt: new Date().toISOString(),
  });
}
