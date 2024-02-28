import { sql } from '@vercel/postgres';
import { NextResponse } from 'next/server';
 
export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const url = searchParams.get('url');
  const uuid = searchParams.get('uuid');
 
  if (!url || !uuid) {
    return new NextResponse('false', { status: 200 });
  }

  try {
    await sql`INSERT INTO tunnel (uuid, url) VALUES (${uuid}, ${url});`;
  } catch (error) {
    return NextResponse.json({ error }, { status: 500 });
  }
 
  // const pets = await sql`SELECT * FROM Pets;`;
  // return NextResponse.json({ pets }, { status: 200 });
  // return new NextResponse(true, { status: 200 });
  return new NextResponse('true', { status: 200 });
}