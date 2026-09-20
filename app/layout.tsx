import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "مصحف الحصري",
  description: "مشروع جمع وإعادة بناء تسجيلات الشيخ محمود خليل الحصري.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ar" dir="rtl">
      <body>{children}</body>
    </html>
  );
}
