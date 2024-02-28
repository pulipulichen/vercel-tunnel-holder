import { sql } from '@vercel/postgres';
import { redirect } from 'next/navigation';
import { NextResponse } from 'next/server';

async function create_table() {
  try {
    const result =
      await sql`CREATE TABLE products ( name varchar(255) );`;
    return NextResponse.json({ result }, { status: 200 });
  } catch (error) {
    return NextResponse.json({ error }, { status: 500 });
  }
}

async function create(formData: File) {
  'use server';
  const { rows } = await sql`
    INSERT INTO products (name)
    VALUES (${formData.get('name')})
  `;
  redirect(`/product/${rows[0].slug}`);
}

export default async function Page() {
  await create_table()

  return (
    <form action={create}>
      <input type="text" name="name" />
      <button type="submit">Submit</button>
    </form>
  );
}