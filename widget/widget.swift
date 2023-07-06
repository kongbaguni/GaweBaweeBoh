//
//  widget.swift
//  widget
//
//  Created by Changyeol Seo on 2023/07/05.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    var data:(data:[(HandUnit.Status,Int)],total:Int) {
        return AppGroup().loadGameData() ?? (data:[(.가위,10),(.바위,10),(.보,10)],total:30)
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            data:data.data,
            total:data.total
        )
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(
            date: Date(),
            configuration: configuration,
            data: data.data,
            total: data.total
        )
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(
                date: entryDate,
                configuration: configuration,
                data: data.data,
                total: data.total
            )
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let data:[(HandUnit.Status,Int)]
    let total:Int
}

struct widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { proxy in
            VStack {
                if(entry.data.count == 0) {
                    Image("gawee")
                        .resizable()
                        .scaledToFit()
                        .frame(width: proxy.size.width)
                        .border(.primary,width:1)
                }
                ForEach(0..<entry.data.count, id:\.self) { idx in
                    HStack {                        
                        Text(entry.data[idx].0.stringValue)
                            .foregroundColor(entry.data[idx].0.colorValue)
                        Text("\(entry.data[idx].1)")
                        Spacer()
                    }
                }
                HStack {
                    if(entry.total > 0) {
                        ForEach(0..<entry.data.count, id:\.self) { idx in
                            let p = Double(entry.data[idx].1) / Double(entry.total)
                            Rectangle()
                                .foregroundColor(entry.data[idx].0.colorValue)
                                .frame(width: (proxy.size.width - 20) * p)
                        }                        
                    }
                    Spacer()
                }
            }
        }.padding(20)
        
    }
}

struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("가위바위보")
        .description("가위바위보 앱의 위젯")
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        widgetEntryView(entry: SimpleEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            data: [(.가위,10),(.바위,10),(.보,10)],
            total: 30
        )
        
        )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
