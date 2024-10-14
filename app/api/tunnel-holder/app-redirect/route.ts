import { sql } from '@vercel/postgres';
import { NextResponse } from 'next/server';
 
export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const url = searchParams.get('u');
 

  if (url) {
    return NextResponse.redirect(url);
  }
  return new NextResponse('false', { status: 200 });
  // return NextResponse.json({ result }, { status: 200 });
}