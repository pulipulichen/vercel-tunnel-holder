import { sql } from '@vercel/postgres';
import { NextResponse } from 'next/server';
 
export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const uuid = searchParams.get('u');
  let uri = searchParams.get('r');
 
  if (!uuid) {
    return new NextResponse('false', { status: 200 });
  }

  const result = await sql`SELECT url FROM tunnel WHERE uuid = ${uuid};`;
  let url = result.rows[0].url

  if (uri) {
    if (!uri.startsWith('/')) {
      uri = '/' + uri
    }
    url = url + uri
  }
  // return NextResponse.json({ pets }, { status: 200 });
  // return new NextResponse(true, { status: 200 });
  // return new NextResponse('true', { status: 200 });
  return NextResponse.redirect(url);
  // return NextResponse.json({ result }, { status: 200 });
}