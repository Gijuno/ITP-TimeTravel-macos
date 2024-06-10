# <xbar.title>산업기능요원 D-Day 카운터</xbar.title>
# <xbar.version>v1.0.2</xbar.version>
# <xbar.author>Gijuno</xbar.author>
# <xbar.author.github>gijuno</xbar.author.github>
# <xbar.desc>심플한 산업기능요원 D-Day 카운터</xbar.desc>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# <swiftbar.refreshOnOpen>true</swiftbar.refreshOnOpen>

########################################
# 'StartDate' 변수에 복무 시작일 작성
# 'Type' 변수에 복무 종류 번호로 작성
# 1: 산업기능요원(현역), 2: 산업기능요원(예비역)
########################################

# CHANGE HERE 

StartDate="2024-01-18"
Type=1  

########################################

case $Type in
  1) 
    EndDate=$(date -j -v +34m -v -1d -f "%Y-%m-%d" "$StartDate" +%Y-%m-%d 2>/dev/null)
    TextType="산업기능요원(현역)"
    ;;
  2) 
    EndDate=$(date -j -v +23m -v -1d -f "%Y-%m-%d" "$StartDate" +%Y-%m-%d 2>/dev/null)
    TextType="산업기능요원(예비역)"
    ;;
  *) 
    echo "Error: Invalid Type value. It should be either 1 or 2."
    ;;
esac

CurrentDate=$(date +%Y-%m-%d)

Dday=$(( ($(date -j -f "%Y-%m-%d" "$EndDate" +%s 2>/dev/null) - $(date +%s)) / 86400 ))
TotalDays=$(( ($(date -j -f "%Y-%m-%d" "$EndDate" +%s) - $(date -j -f "%Y-%m-%d" "$StartDate" +%s)) / 86400 ))

EndDateYear=$(date -j -f "%Y-%m-%d" "$EndDate" +%Y)
CurrentYear=$(date +%Y)
YearsDiff=$((EndDateYear - CurrentYear))

EndDateMonth=$(date -j -f "%Y-%m-%d" "$EndDate" +%m)
CurrentMonth=$(date +%m)
MonthsDiff=$((EndDateMonth - CurrentMonth))
if [ $MonthsDiff -lt 0 ]; then
  YearsDiff=$((YearsDiff - 1))
  MonthsDiff=$((12 + MonthsDiff))
fi

EndDateDay=$(date -j -f "%Y-%m-%d" "$EndDate" +%d)
CurrentDay=$(date +%d)
DaysDiff=$((EndDateDay - CurrentDay))

if [ $DaysDiff -lt 0 ]; then
  if [ $MonthsDiff -eq 0 ]; then
    YearsDiff=$((YearsDiff - 1))
    MonthsDiff=11
  else
    MonthsDiff=$((MonthsDiff - 1))
  fi
  DaysInPrevMonth=$(cal $(date -j -v-1m -f "%Y-%m-%d" "$EndDate" +%m) $(date -j -v-1m -f "%Y-%m-%d" "$EndDate" +%Y) | awk 'NF {DAYS = $NF}; END {print DAYS}')
  DaysDiff=$((DaysDiff + DaysInPrevMonth))
fi

ProgressDays=$((TotalDays - Dday))
ProgressPercent=$(awk -v progress="$ProgressDays" -v total="$TotalDays" 'BEGIN { printf "%.2f", (progress/total)*100 }')

GraphBarCount=$(echo "scale=0; $ProgressPercent / 2" | bc)

GraphBar="["
if [ "$GraphBarCount" -gt 0 ]; then
  for i in $(seq 1 $GraphBarCount); do GraphBar="${GraphBar}l"; done
fi
if [ "$GraphBarCount" -lt 50 ]; then
  for i in $(seq 1 $((50-GraphBarCount))); do GraphBar="${GraphBar}."; done
fi
GraphBar="${GraphBar}]"

echo "🪖 D-$Dday"
echo "---"
echo "🪖 $TextType | color=green"
echo "📅 $StartDate ~ $EndDate | color=blue"
echo "🏠 전체복무일: ""$TotalDays 일 | color=red"
echo "$YearsDiff년 $MonthsDiff개월 $DaysDiff일 남았습니다 | color=yellow"
echo "$GraphBar $ProgressPercent% | color=red"