package vo; // Value Object


// 데이터 용도 diary테이블의 한행을 저장하는 용도
public class Diary {
	public int diaryNo;
	
	// 다이어리 객체가 한행 >>> 여러개의 정보?를 담기 위해서는 배열이 필요하대
	// 근데 배열이 불편하니까 이제 ArrayList ㄱㄱ
	
	public String diaryDate;
	public String diaryTodo;
	public String createDate;
	
	// 게터세트는 위의 친구들에게 접근할 수 있는 메서드
	
	
}
