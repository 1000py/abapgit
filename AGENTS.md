# SAP ABAP Code Generation Rules for abapgit

이 문서는 OpenAI Codex(또는 AI 모델)를 사용하여 SAP ABAP 프로그램을 생성하고, abapgit을 통해 SAP 시스템에 원활하게 반영하기 위한 파일 구조 및 명명 규칙을 정의합니다.

## 1. 기본 디렉토리 및 파일 명명 규칙 (Naming Conventions)

abapgit은 파일 확장자와 파일명을 기반으로 오브젝트 유형을 판별합니다. 모든 파일명은 **대소문자를 엄격하게 구분**하므로 주의해야 합니다.

* **패키지 (Package) 내부에 생성되는 오브젝트 파일 구조:**
  * 모든 소스 파일은 패키지 루트 디렉토리에 위치해야 합니다.
  * 파일명 형식: `<object_name>.<object_type>.<extension>` 또는 abapgit 표준 포맷 준수

---

## 2. 작업 시작 순서

*   **먼저 `CODE_SUMMARY.md`를 확인하세요.** 변수, 함수, 클래스, 파일 책임을 찾을 때 전체 파일을 훑기 전에 `CODE_SUMMARY.md`의 파일 맵과 함수 요약을 먼저 봅니다.

*   **수정할 파일을 1~3개로 좁히세요.** 기능이 여러 영역에 걸리더라도 먼저 핵심 책임 파일을 찾고, 필요한 경우에만 인접 파일을 엽니다.

*   **큰 파일을 다시 키우지 마세요.** 새 기능이 길어질 경우 기존 책임에 맞는 작은 파일을 추가하거나, 이미 분리된 파일에만 붙입니다.

*   **수정 후 요약 문서를 갱신하세요.** 새 전역 변수, 클래스 프로퍼티, 핵심 함수, 이벤트 흐름, 파일 책임이 바뀌면 `CODE_SUMMARY.md`를 함께 갱신합니다.

## 3. 오브젝트별 파일 생성 규칙

### ① 실행 가능한 프로그램 (Executable Program / Report - PROG)
리포트 프로그램은 소스 코드 파일과 XML 메타데이터 파일 **2개가 쌍**으로 존재해야 합니다.
1. **파일구성**
   * 파일안에 abapgit 사용을위한 xml파일과 src명의 폴더로 구성하며 src 폴더안에 소스 코드 파일과 메타데이터파일을 생성
   * 파일은 최종으로 압축파일로 만든다.
**파일구성 예시**
  FOLDER
  ㄴ ABAPGIT.XML
  ㄴ src
     ㄴ 소스코드파일
     ㄴ 메타데이터파일
2. **ABAPGIT XML 파일:**
   * **파일명:** `yyK02574_p01.xml` (예: `yyK02574_alv01.prog.abap`)
   * **내용:** 순수 ABAP 실행 코드 (`REPORT yyK02574_alv01.`로 시작)   
3. **소스 코드 파일:**
   * **파일명:** `yyK02574프로그램명.prog.abap` (예: `yyK02574_alv01.prog.abap`)
   * **내용:** 순수 ABAP 실행 코드 (`REPORT yyK02574_alv01.`로 시작)
4. **메타데이터 파일:**
   * **파일명:** `yyK02574프로그램명.prog.xml` (예: `yyK02574_alv01.prog.xml`)
   * **내용:** 프로그램 속성(Title, Status 등)을 담은 XML 구조



**[XML 예시 (`abapgit.xml`)]**
```abapgit xml
<?xml version="1.0" encoding="utf-8"?>
<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
 <asx:values>
  <DATA>
   <NAME>$YYK02574_P01</NAME>
   <MASTER_LANGUAGE>E</MASTER_LANGUAGE>
   <STARTING_FOLDER>/src/</STARTING_FOLDER>
   <FOLDER_LOGIC>PREFIX</FOLDER_LOGIC>
  </DATA>
 </asx:values>
</asx:abap>


**[XML 예시 (`yyK02574_alv01.prog.xml`)]**
```xml
<?xml version="1.0" encoding="utf-8"?>
<abapGit version="v1.0.0" serializer="LCL_OBJECT_PROG" serializer_version="v1.0.0">
 <asx:abap xmlns:asx="[http://www.sap.com/abapxml](http://www.sap.com/abapxml)" version="1.0">
  <asx:values>
      <PROGDIR>
        <NAME>YYK02574_alv01</NAME>
        <SUBC>1</SUBC>
        <FIXPT>X</FIXPT>
        <UCCHECK>X</UCCHECK>
      </PROGDIR>
      <TPOOL>
        <item>
          <ID>R</ID>
          <ENTRY>Simple ALV report for flight data</ENTRY>
          <LENGTH>33</LENGTH>
        </item>
      </TPOOL>
  </asx:values>
 </asx:abap>
</abapGit>