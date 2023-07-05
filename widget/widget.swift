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
    let appGroup = AppGroup()
    var data:(data:[(Color,Int)],total:Int) {
        return appGroup.loadGameData() ?? (data:[],total:0)
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        
        SimpleEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            data: data.data,
            total: data.total
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
    let data:[(Color,Int)]
    let total:Int
}

struct widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { proxy in
            VStack {
                ForEach(0..<entry.data.count, id:\.self) { idx in
                    HStack {
                        Text(entry.data[idx].0.stringValue)
                            .foregroundColor(entry.data[idx].0)
                        Text("\(entry.data[idx].1)")
                    }
                }
                HStack {
                    ForEach(0..<entry.data.count, id:\.self) { idx in
                        let p = Double(entry.data[idx].1) / Double(entry.total)
                        Rectangle()
                            .foregroundColor(entry.data[idx].0)
                            .frame(width: (proxy.size.width - 40) * p)
                            .border(.primary,width: 2)
                    }
                }.padding(10)
            }
        }
        
    }
}

struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        widgetEntryView(entry: SimpleEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            data: [(.red,10),(.blue,20),(.green,30)],
            total: 60
        )
        
        )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
