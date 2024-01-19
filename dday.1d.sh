########################################
# 'StartDate' 변수에 복무 시작일 작성
# 'Type' 변수에 복무 종류 번호로 작성
# 1: 사회복무요원(현역), 2: 사회복무요원(예비역)
########################################

StartDate="2024-01-18"
Type=1
CurrentDate=$(date +%Y-%m-%d)

case $Type in
  1) EndDate=$(date -j -v +34m -v -1d -f "%Y-%m-%d" "$StartDate" +%Y-%m-%d 2>/dev/null) ;;
  2) EndDate=$(date -j -v +23m -v -1d -f "%Y-%m-%d" "$StartDate" +%Y-%m-%d 2>/dev/null) ;;
  *) echo "Error: Invalid Type value. It should be either 1 or 2." ;;
esac

Dday=$(( ($(date -j -f "%Y-%m-%d" "$EndDate" +%s 2>/dev/null) - $(date +%s)) / 86400 ))
TotalDays=$(( ($(date -j -f "%Y-%m-%d" "$EndDate" +%s) - $(date -j -f "%Y-%m-%d" "$StartDate" +%s)) / 86400 ))

EndDateComponents=($(date -j -f "%Y-%m-%d" "$EndDate" +%Y +%m +%d))
CurrentDateComponents=($(date +%Y +%m +%d))
YearsDiff=$((EndDateComponents[0] - CurrentDateComponents[0]))
MonthsDiff=$((EndDateComponents[1] - CurrentDateComponents[1]))
DaysDiff=$((EndDateComponents[2] - CurrentDateComponents[2]))

if [ $DaysDiff -lt 0 ]; then
  MonthsDiff=$((MonthsDiff - 1))
  DaysInPrevMonth=$(cal ${EndDateComponents[1]} ${EndDateComponents[0]} | awk 'NF {DAYS = $NF}; END {print DAYS}')
  DaysDiff=$((DaysDiff + DaysInPrevMonth))
fi

if [ $MonthsDiff -lt 0 ]; then
  YearsDiff=$((YearsDiff - 1))
  MonthsDiff=$((12 + MonthsDiff))
fi


echo "🪖 D-$Dday"
echo "---"
echo "📅 $StartDate ~ $EndDate"
echo "🏠 전체복무일: $TotalDays 일"
echo "$YearsDiff년 $MonthsDiff개월 $DaysDiff일 남았습니다"
