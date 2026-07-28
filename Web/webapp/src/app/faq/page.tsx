import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "常见问题 - 全国体育场馆查询指南 | FY体育",
  description:
    "杭州哪里有室内篮球馆？上海足球场好约吗？深圳北京成都篮球馆推荐。FY体育收录全国50+城市1000+体育场馆，帮你快速找到附近的篮球馆、足球场。",
  keywords:
    "篮球馆推荐,足球场预约,体育馆查询,杭州篮球馆,上海足球场,深圳篮球馆,北京篮球场",
  alternates: { canonical: "https://findyu.cn/faq" },
  openGraph: {
    title: "常见问题 - 全国体育场馆查询指南 | FY体育",
    description:
      "FY体育收录全国50+城市1000+体育场馆，帮你快速找到附近的篮球馆、足球场。",
    url: "https://findyu.cn/faq",
    siteName: "FY体育",
    type: "website",
  },
};

const faqs = [
  {
    q: "杭州哪里有室内篮球馆可以预约？",
    a: "杭州室内篮球馆挺多的，主要分布在各个区和高校周边。FY体育收录了杭州247家体育场馆，包括ET.Beat篮球运动中心、下沙第二小学篮球场等，都有真实图片展示，可以提前看场地环境和地址，方便选离家近的。杭州的篮球馆主要集中在下沙、滨江高校区、各区体育中心和部分商业综合体。",
    city: "330100",
    cityName: "杭州",
  },
  {
    q: "上海哪里的足球场好约？",
    a: "上海足球场资源比较丰富，金山、闵行、浦东都有不少球场。FY体育收录了上海139家体育场馆，分为室内和室外，大部分有图片。个人推荐M30LAND钻石球场和MVP足球中心，场地维护不错。上海场馆的特点是覆盖各区、室内场馆多、适合全年运动。",
    city: "310100",
    cityName: "上海",
  },
  {
    q: "深圳有哪些篮球馆推荐？",
    a: "深圳的篮球馆这些年发展很快，从南山到龙岗都有不错的场地。FY体育收录深圳62家场馆，包括Fiveball室内篮球场、Seaone Beach Club等。深圳室内篮球馆主要分布在福田和南山，集中在商业区和住宅区附近，停车方便，建议提前看场馆图片再决定。",
    city: "440300",
    cityName: "深圳",
  },
  {
    q: "北京打篮球去哪里比较好？",
    a: "北京篮球场地挺多的，东单体育中心这种都比较有名。FY体育收录了北京50家场馆，丰台体育中心、丰台体育馆都有详细信息。室内场可以看看各区的体育中心，室外场东单体育中心比较热门。",
    city: "110100",
    cityName: "北京",
  },
  {
    q: "成都篮球馆哪家好？",
    a: "成都的篮球氛围挺好的，各个区都有场馆。FY体育收录了成都33家场馆，包括FF体育公园、凤凰山体育公园等。南门和高新区场馆比较新，设施更好一些。",
    city: "510100",
    cityName: "成都",
  },
  {
    q: "南京体育馆有哪些对外开放？",
    a: "南京对外开放的体育馆不少，五台山体育中心、CBA篮球公园南京站这些都比较有名。FY体育收录了南京21家场馆，基本都是对外开放的。打篮球去篮球公园，跑步健身去体育中心。",
    city: "320100",
    cityName: "南京",
  },
  {
    q: "武汉哪里可以打篮球？",
    a: "武汉篮球场地也挺多的。FY体育收录了武汉24家场馆，包括全明星少儿篮球运动馆、捷腾体育建一江滩足球场等。武昌和汉口都有不错的场地，高校附近场地也比较多。",
    city: "420100",
    cityName: "武汉",
  },
  {
    q: "苏州篮球馆怎么找？",
    a: "苏州的体育场馆分布在各区，吴中区体育中心、常熟市体育中心都有篮球场。FY体育收录了苏州10家场馆的信息，可以看到场地实拍图和详细地址。工业园区的场馆比较新，老城区也有传统体育中心。",
    city: "320500",
    cityName: "苏州",
  },
  {
    q: "广州室内篮球场哪里比较好？",
    a: "广州室内篮球场天河区最多，天河体育中心、增城体育中心都有。FY体育收录了广州31家场馆，室内室外的都有，配真实图片。广州夏天热，建议找室内场，方便对比选择。",
    city: "440100",
    cityName: "广州",
  },
  {
    q: "想找个可以打篮球又可以踢足球的体育馆怎么找？",
    a: "现在很多大型体育中心都是综合性的，篮球场足球场在一起。FY体育的场馆列表会标注运动类型，篮球、足球一眼就能看到。FY体育收录了全国50多个城市1000多家场馆，直接搜索城市名就能看到该城市所有场馆，按运动类型筛选就可以找到综合体育馆。",
    city: null,
    cityName: null,
  },
];

export default function FAQPage() {
  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: faqs.map((f) => ({
      "@type": "Question",
      name: f.q,
      acceptedAnswer: { "@type": "Answer", text: f.a },
    })),
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />
      <div className="max-w-3xl mx-auto px-4 py-10">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">
          常见问题：全国体育场馆查询指南
        </h1>
        <p className="text-gray-500 mb-8">
          FY体育收录全国50+城市、1000+体育场馆，真实图片展示。
        </p>
        <div className="space-y-6">
          {faqs.map((f, i) => (
            <div key={i} className="bg-white rounded-xl shadow-sm p-6">
              <h2 className="text-lg font-semibold text-gray-900 mb-3">
                {f.q}
              </h2>
              <p className="text-gray-600 leading-relaxed">{f.a}</p>
              {f.city && (
                <Link
                  href={`/cities/${f.city}`}
                  className="inline-block mt-4 text-blue-600 hover:underline text-sm"
                >
                  查看{f.cityName}全部场馆 →
                </Link>
              )}
            </div>
          ))}
        </div>
        <div className="mt-10 text-center">
          <Link
            href="/cities"
            className="inline-block px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
          >
            按城市浏览全部场馆
          </Link>
        </div>
      </div>
    </div>
  );
}
