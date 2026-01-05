import Link from 'next/link'
import dynamic from 'next/dynamic'
import { fetchJson } from '@/lib/api'
import NavigationMenu from '@/components/NavigationMenu'

// 使用动态导入延迟加载客户端组件，避免 SSR 问题
// Gallery 是客户端组件（使用 useState），禁用 SSR 以避免 hydration 错误
const Gallery = dynamic(() => import('@/components/Gallery'), { ssr: false })
// Reviews 是客户端组件（使用 useState 和日期格式化），禁用 SSR
const Reviews = dynamic(() => import('@/components/Reviews'), { ssr: false })
const ReviewForm = dynamic(() => import('@/components/ReviewForm'), { ssr: false })

export default async function VenueDetailPage({ params }: { params: { id: string } }) {
  const venueId = params.id
  
  let detail: any = null
  let images: any = { items: [] }
  let reviews: any = { items: [] }
  
  try {
    [detail, images, reviews] = await Promise.all([
      fetchJson(`/venues/${venueId}`).catch(() => null),
      fetchJson(`/venues/${venueId}/images`).catch(() => ({ items: [] })),
      fetchJson(`/venues/${venueId}/reviews`).catch(() => ({ items: [] })),
    ])
  } catch (error) {
    // 静默处理错误，继续渲染
    // console.error('Failed to fetch venue data:', error)
  }
  
  const v = detail?.id ? detail : null
  // 传递图片对象（包含 id 和 url），以便 Gallery 组件可以删除图片
  const imageItems = images?.items?.map((x: any) => ({ id: x.id, url: x.url })) ?? []
  
  // 计算平均评分（确保格式一致）
  const avgRating = reviews?.items?.length > 0
    ? Number((reviews.items.reduce((sum: number, r: any) => sum + (r.rating || 0), 0) / reviews.items.length).toFixed(1))
    : null

  return (
    <main className="container-page py-12 bg-white">
      <div className="mb-8">
        <Link href="/map" className="link-nike inline-flex items-center gap-2">
          ← 返回地图
        </Link>
      </div>
      <div className="grid grid-cols-1 lg:grid-cols-[2fr_1fr] gap-12">
        <div>
          <div className="mb-8">
            <Gallery urls={imageItems} venueId={venueId} />
          </div>
          <h1 className="text-heading font-bold mb-4 tracking-tight">{v ? v.name : `场地 #${venueId}`}</h1>
          <div className="text-body-sm text-textSecondary mb-8 uppercase tracking-wide">
            {v ? (
              <>
                {v.sportType === 'basketball' ? '篮球' : '足球'} · {v.indoor ? '室内' : '室外'} · {v.priceMin ? `¥${v.priceMin}` : '免费'}
                {avgRating !== null && <span className="ml-2">· {avgRating.toFixed(1)} 评分</span>}
              </>
            ) : '加载中…'}
          </div>

          <section className="border-t border-border pt-8 mb-8">
            <h2 className="text-heading-sm font-bold mb-6 tracking-tight">关键信息</h2>
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-6 text-body-sm">
              {v?.districtCode && (() => {
                // 区级代码到名称的映射（简化版，实际可以从API获取）
                const districtMap: Record<string, string> = {
                  '110101': '东城区', '110102': '西城区', '110105': '朝阳区', '110106': '丰台区',
                  '110107': '石景山区', '110108': '海淀区', '110109': '门头沟区', '110111': '房山区',
                  '110112': '通州区', '110113': '顺义区', '110114': '昌平区', '110115': '大兴区',
                  '110116': '怀柔区', '110117': '平谷区', '110118': '密云区', '110119': '延庆区',
                  '310101': '黄浦区', '310104': '徐汇区', '310105': '长宁区', '310106': '静安区',
                  '310107': '普陀区', '310109': '虹口区', '310110': '杨浦区', '310112': '闵行区',
                  '310113': '宝山区', '310114': '嘉定区', '310115': '浦东新区', '310116': '金山区',
                  '310117': '松江区', '310118': '青浦区', '310120': '奉贤区', '310151': '崇明区',
                  '440103': '荔湾区', '440104': '越秀区', '440105': '海珠区', '440106': '天河区',
                  '440111': '白云区', '440112': '黄埔区', '440113': '番禺区', '440114': '花都区',
                  '440115': '南沙区', '440117': '从化区', '440118': '增城区',
                  '440303': '罗湖区', '440304': '福田区', '440305': '南山区', '440306': '宝安区',
                  '440307': '龙岗区', '440308': '盐田区', '440309': '龙华区', '440310': '坪山区',
                  '440311': '光明区',
                  '330102': '上城区', '330105': '拱墅区', '330106': '西湖区', '330108': '滨江区',
                  '330109': '萧山区', '330110': '余杭区', '330111': '富阳区', '330112': '临安区',
                  '330113': '临平区', '330114': '钱塘区',
                  '320102': '玄武区', '320104': '秦淮区', '320105': '建邺区', '320106': '鼓楼区',
                  '320111': '浦口区', '320113': '栖霞区', '320114': '雨花台区', '320115': '江宁区',
                  '320116': '六合区', '320117': '溧水区', '320118': '高淳区',
                  '510104': '锦江区', '510105': '青羊区', '510106': '金牛区', '510107': '武侯区',
                  '510108': '成华区', '510112': '龙泉驿区', '510113': '青白江区', '510114': '新都区',
                  '510115': '温江区', '510116': '双流区', '510117': '郫都区', '510118': '新津区',
                  '420102': '江岸区', '420103': '江汉区', '420104': '硚口区', '420105': '汉阳区',
                  '420106': '武昌区', '420107': '青山区', '420111': '洪山区', '420112': '东西湖区',
                  '420113': '汉南区', '420114': '蔡甸区', '420115': '江夏区', '420116': '黄陂区',
                  '420117': '新洲区',
                  '120101': '和平区', '120102': '河东区', '120103': '河西区', '120104': '南开区',
                  '120105': '河北区', '120106': '红桥区', '120110': '东丽区', '120111': '西青区',
                  '120112': '津南区', '120113': '北辰区', '120114': '武清区', '120115': '宝坻区',
                  '120116': '滨海新区', '120117': '宁河区', '120118': '静海区', '120119': '蓟州区',
                  '500101': '万州区', '500102': '涪陵区', '500103': '渝中区', '500104': '大渡口区',
                  '500105': '江北区', '500106': '沙坪坝区', '500107': '九龙坡区', '500108': '南岸区',
                  '500109': '北碚区', '500110': '綦江区', '500111': '大足区', '500112': '渝北区',
                  '500113': '巴南区', '500114': '黔江区', '500115': '长寿区',
                }
                const districtName = districtMap[v.districtCode] || v.districtCode
                return (
                  <div>
                    <div className="text-textSecondary uppercase tracking-wide mb-1">区级</div>
                    <div className="font-medium">{districtName}</div>
                  </div>
                )
              })()}
              <div>
                <div className="text-textSecondary uppercase tracking-wide mb-1">地址</div>
                <div className="font-medium">
                  {v && v.location ? (
                    <NavigationMenu
                      address={v.address || '地址未填写'}
                      location={v.location}
                      name={v.name}
                    />
                  ) : (
                    <span>{v?.address ?? '-'}</span>
                  )}
                </div>
              </div>
              <div>
                <div className="text-textSecondary uppercase tracking-wide mb-1">收费情况</div>
                <div className="font-medium">
                  {v?.priceMin !== undefined && v?.priceMin !== null ? (
                    v.priceMax && v.priceMax !== v.priceMin ? (
                      `¥${v.priceMin} - ¥${v.priceMax}/小时`
                    ) : (
                      `¥${v.priceMin}/小时`
                    )
                  ) : (
                    '免费'
                  )}
                </div>
              </div>
              <div>
                <div className="text-textSecondary uppercase tracking-wide mb-1">室内外</div>
                <div className="font-medium">{v?.indoor ? '室内' : '室外'}</div>
              </div>
              <div>
                <div className="text-textSecondary uppercase tracking-wide mb-1">是否对外开放</div>
                <div className="font-medium">{v?.isPublic !== false ? '对外开放' : '仅限内部'}</div>
              </div>
              <div>
                <div className="text-textSecondary uppercase tracking-wide mb-1">联系方式</div>
                <div className="font-medium">{v?.contact || '未提供'}</div>
              </div>
            </div>
          </section>

          <section className="border-t border-border pt-8 mb-8">
            <h2 className="text-heading-sm font-bold mb-6 tracking-tight">用户点评</h2>
            <Reviews items={reviews?.items ?? []} />
          </section>

          <section className="border-t border-border pt-8">
            <h2 className="text-heading-sm font-bold mb-6 tracking-tight">写点评</h2>
            <ReviewForm venueId={venueId} />
          </section>
        </div>

        <aside className="space-y-6">
          {v && v.location && (
            <div className="border border-border p-6" style={{ borderRadius: '4px' }}>
              <h3 className="text-heading-sm font-bold mb-4">位置信息</h3>
              <div className="space-y-3 text-body-sm">
                <div>
                  <div className="text-textSecondary uppercase tracking-wide mb-1">地址</div>
                  <NavigationMenu
                    address={v.address || '地址未填写'}
                    location={v.location}
                    name={v.name}
                  />
                </div>
                <div>
                  <div className="text-textSecondary uppercase tracking-wide mb-1">收费情况</div>
                  <div className="font-medium">
                    {v.priceMin !== undefined && v.priceMin !== null ? (
                      v.priceMax && v.priceMax !== v.priceMin ? (
                        `¥${v.priceMin} - ¥${v.priceMax}/小时`
                      ) : (
                        `¥${v.priceMin}/小时`
                      )
                    ) : (
                      '免费'
                    )}
                  </div>
                </div>
                <div>
                  <div className="text-textSecondary uppercase tracking-wide mb-1">是否对外开放</div>
                  <div className="font-medium">{v.isPublic !== false ? '对外开放' : '仅限内部'}</div>
                </div>
                <div>
                  <div className="text-textSecondary uppercase tracking-wide mb-1">联系方式</div>
                  <div className="font-medium">{v.contact || '未提供'}</div>
                </div>
              </div>
            </div>
          )}
          <button className="btn-secondary w-full">收藏</button>
        </aside>
      </div>
    </main>
  )
}


