import { NextResponse } from 'next/server';
 
function generateUUID() {
  // Generate a random hexadecimal string of length 4
  function generateHex() {
    return Math.floor((1 + Math.random() + (new Date()).getTime()) * 0x10000)
      .toString(16)
      .substring(1);
  }

  // Concatenate random hexadecimal strings to form a UUID
  return (
    generateHex() +
    generateHex() +
    '-' +
    generateHex() +
    '-' +
    generateHex() +
    '-' +
    generateHex() +
    '-' +
    generateHex() +
    generateHex() +
    generateHex()
  );
}

export async function GET(request: Request){
  return new NextResponse(generateUUID(), { status: 200 });
}