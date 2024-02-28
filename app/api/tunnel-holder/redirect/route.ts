import { sql } from '@vercel/postgres';
import { NextResponse } from 'next/server';
 
export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const uuid = searchParams.get('d');
 
  if (!uuid) {
    return new NextResponse('false', { status: 200 });
  }

  const result = await sql`SELECT url FROM tunnel WHERE uuid = ${uuid};`;
  const url = result.rows[0].url
  // return NextResponse.json({ pets }, { status: 200 });
  // return new NextResponse(true, { status: 200 });
  // return new NextResponse('true', { status: 200 });
  return NextResponse.redirect(url);
  // return NextResponse.json({ result }, { status: 200 });
}