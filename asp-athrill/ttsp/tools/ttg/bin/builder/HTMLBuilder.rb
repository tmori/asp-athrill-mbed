#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Graduate School of Information Science,
#                             Aichi Prefectural Univ., JAPAN
#
#  �嵭����Ԥϡ��ʲ���(1)��(4)�ξ������������˸¤ꡤ�ܥ��եȥ���
#  �����ܥ��եȥ���������Ѥ�����Τ�ޤࡥ�ʲ�Ʊ���ˤ���ѡ�ʣ������
#  �ѡ������ۡʰʲ������ѤȸƤ֡ˤ��뤳�Ȥ�̵���ǵ������롥
#  (1) �ܥ��եȥ������򥽡��������ɤη������Ѥ�����ˤϡ��嵭������
#      ��ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ��꤬�����Τޤޤη��ǥ���
#      ����������˴ޤޤ�Ƥ��뤳�ȡ�
#  (2) �ܥ��եȥ������򡤥饤�֥������ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ�����Ǻ����ۤ�����ˤϡ������ۤ�ȼ���ɥ�����ȡ�����
#      �ԥޥ˥奢��ʤɡˤˡ��嵭�����ɽ�����������Ѿ�浪��Ӳ���
#      ��̵�ݾڵ����Ǻܤ��뤳�ȡ�
#  (3) �ܥ��եȥ������򡤵�����Ȥ߹���ʤɡ�¾�Υ��եȥ�������ȯ�˻�
#      �ѤǤ��ʤ����Ǻ����ۤ�����ˤϡ����Τ����줫�ξ�����������
#      �ȡ�
#    (a) �����ۤ�ȼ���ɥ�����ȡ����Ѽԥޥ˥奢��ʤɡˤˡ��嵭����
#        �ɽ�����������Ѿ�浪��Ӳ�����̵�ݾڵ����Ǻܤ��뤳�ȡ�
#    (b) �����ۤη��֤��̤�������ˡ�ˤ�äơ�TOPPERS�ץ������Ȥ�
#        ��𤹤뤳�ȡ�
#  (4) �ܥ��եȥ����������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������뤤���ʤ�»
#      ������⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ����դ��뤳�ȡ�
#      �ޤ����ܥ��եȥ������Υ桼���ޤ��ϥ���ɥ桼������Τ����ʤ���
#      ͳ�˴�Ť����ᤫ��⡤�嵭����Ԥ����TOPPERS�ץ������Ȥ�
#      ���դ��뤳�ȡ�
#
#  �ܥ��եȥ������ϡ�̵�ݾڤ��󶡤���Ƥ����ΤǤ��롥�嵭����Ԥ�
#  ���TOPPERS�ץ������Ȥϡ��ܥ��եȥ������˴ؤ��ơ�����λ�����Ū
#  ���Ф���Ŭ������ޤ�ơ������ʤ��ݾڤ�Ԥ�ʤ����ޤ����ܥ��եȥ���
#  �������Ѥˤ��ľ��Ū�ޤ��ϴ���Ū�������������ʤ�»���˴ؤ��Ƥ⡤��
#  ����Ǥ�����ʤ���
#
#  $Id: HTMLBuilder.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "bin/builder/CodeBuilder.rb"
require "bin/product/HTMLCode.rb"

#�ޥ���ץ��å���ʬ�����顼�ꥹ��
DEEP_COLOR_LIST = ["#FFFFFF", "lightcoral", "steelblue", "aquamarine", "#FFFFD7"]
PALE_COLOR_LIST = ["#FFFFFF", "#FFE3E3", "#E3EEFF", "#E3FFE3", "#FFFFD7"]
# ���ϴؿ���Ʊ����Ȥ���ϰʲ��򥢥󥳥���
# STDOUT.sync = true
module TTG

  #==================================================================
  # ���饹̾: HTMLBuilder
  # ����  ��: ��֥����ɤ����Ѥ���HTML�ե�������������륯�饹
  #==================================================================
  class HTMLBuilder < CodeBuilder
    include CommonModule

    #================================================================
    # ������: ���󥹥ȥ饯��
    #================================================================
    def initialize()
      @sHTMLCode  = ""   # HTML���Ϥ���ʸ�������Ū���ݻ�����
      @@cHTMLCode = nil  # HTML�����ɤ��ݻ�����
      @nRowSpan   = 0    # ����ǥ��������ιԿ����ݻ�����
      @aProcUnits = []   # �о줹�����ñ�̤��ݻ�����
      @sTestID    = ""   # �ƥ��ȥ��ʥꥪID
      @cConf      = Config.new() # ����ե��������
    end


    #================================================================
    # ������: ��֥����ɤ���HTML�ե�������������ƽ��Ϥ���
    #================================================================
    def build(cIntermediateCode)
      check_class(IntermediateCode, cIntermediateCode) # ��֥����ɤΥ��󥹥���
      cnt = 0

      # �إå������ɲ�
      add_header()

      cIntermediateCode.aCode.each{ |hScenarioes|
        hScenarioes.each{ |sScenarioID, aScenario|
          if (sScenarioID == IMC_COMMON)
            next
          end

          @sTestID    = sScenarioID
          @aProcUnits = []
          @aScenario  = aScenario # ��®���Τ���

          # �о줹�����ñ�̤�ȴ���Ф�
          cIntermediateCode.hProcUnitInfo.each_key{ |sProcUnit|
            sScenarioIDLow = sScenarioID.downcase
            sProcUnitLow   = sProcUnit.downcase

            if (/\A#{sScenarioIDLow}/ =~ sProcUnitLow)
              @aProcUnits.push(sProcUnit.sub(@sTestID+"_", ""))
            end
          }
          @aProcUnits.sort!

          # �ƥ��ȥ��ʥꥪ���Ȥ�ɽ���ɲ�
          @sHTMLCode.concat(%Q[<font size = "6">#{@sTestID}</font><br>#{TTG_NL}])
          @sHTMLCode.concat("<table border=1>#{TTG_NL}")
          make_body()
          @sHTMLCode.concat("</table>#{TTG_NL}")
          @sHTMLCode.concat("<br>#{TTG_NL}")
        }
      }

      # �եå������ɲ�
      add_footer()

      # HTML�����ɤ�����
      @@cHTMLCode = HTMLCode.new(@sHTMLCode)
    end


    #================================================================
    # ������: �إå����Υ����ɤ��ɲä���
    #================================================================
    def add_header()
      sHeader = <<-EOS
<html>
<head>
</head>
<body>
      EOS
      @sHTMLCode.concat(sHeader)

      # ���顼��������ɲ�
      if (@cConf.is_fmp?())
        1.upto(@cConf.get_prc_num()){ |prcid|
          @sHTMLCode.concat(%Q[��<font style="font-size:24px; background-color:#{PALE_COLOR_LIST[prcid]}">�ץ��å�#{prcid}</font>#{TTG_NL}])
        }
        @sHTMLCode.concat("<br><br>#{TTG_NL}")
      end
    end


    #================================================================
    # ������: �եå����Υ����ɤ��ɲä���
    #================================================================
    def add_footer()
      sFooter = <<-EOS
</body>
</html>
      EOS

      @sHTMLCode.concat(sFooter)
    end


    #================================================================
    # ������: ��֥����ɤ���HTML�����ɤ�������ʬ����������
    #================================================================
    def make_body()

      @aScenario.each{ |hCondition|
        hCondition.each{ |sCondition, aBlocks|
          if (aBlocks.empty?())
            # ����ConditionSync�����Ф�
            next
          end

          # ����ǥ�����󤴤Ȥ˽���ñ�̹Ԥ���Ϳ
          add_processing_units(sCondition)

          aBlocks.each{ |hBlocks|
            hBlocks.each{ |sBlock, aCodeInfo|
              @aCodeInfo = aCodeInfo # ��®���Τ���
              # �֥�å����Ȥ˽���
              add_lines()
            }
          @sHTMLCode.concat("#{TTG_NL}")
          }

          # �Ǻ��Ԥη��Կ�������
          replace_rowspan(sCondition)
        }
      }
    end


    #================================================================
    # ������: ����ñ�̹Ԥ��ɲä���
    #================================================================
    def add_processing_units(sConditionID)
      check_class(String, sConditionID) # ����ǥ������ID

      @sHTMLCode.concat(%Q[<tr><th rowspan = "SPAN:#{sConditionID}">#{sConditionID}</th>])

      @aProcUnits.each{ |sProcUnit|
        @sHTMLCode.concat("#{TTG_NL}")
        @sHTMLCode.concat(%Q[<th bgcolor = "gainsboro">#{sProcUnit}</th>])
      }

      @sHTMLCode.concat("</tr>#{TTG_NL}")
    end


    #================================================================
    # ������: rowspan°�����֤�����
    #================================================================
    def replace_rowspan(sConditionID)
      @sHTMLCode = @sHTMLCode.sub("SPAN:#{sConditionID}", "#{@nRowSpan+1}")
      @nRowSpan = 0
    end


    #================================================================
    # ������: Ϳ����줿�����ɾ�����ɲä���
    #================================================================
    def add_lines()
      @aCodeInfo.each{|sObjID, sCode, nBootCnt, nPrcID, lAtr|
        nColumn = @aProcUnits.index(sObjID.sub(@sTestID+"_", "")) # ���
        if (@cConf.is_fmp?())
          sColor  = PALE_COLOR_LIST[nPrcID]                       # ���顼������
        else
          sColor  = PALE_COLOR_LIST[1]
        end
        sCode   = sCode.sub(@sTestID+"_", "")                     # ���ϥ�����

        if (is_hidden?(lAtr))
          next
        end

        # �Կ������󥿡��Υ��󥯥����
        @nRowSpan += 1

        @sHTMLCode.concat("#{TTG_TB}")
        @sHTMLCode.concat("<tr>")

        nColumnSize = @aProcUnits.size()
        nColumnSize.times{ |index|
          if (index == nColumn)
            @sHTMLCode.concat(%Q[<td bgcolor = "#{sColor}"> #{sCode} </td>])
          else
            @sHTMLCode.concat("<td>��</td>")
          end
        }

        @sHTMLCode.concat("</tr>#{TTG_NL}")
      }
    end


    #=================================================================
    # ��  ��: °���򸫤ơ����������ɤ��ɤ�����Ƚ�Ǥ���
    #=================================================================
    def is_hidden?(lAtr)
      check_class(Symbol, lAtr) # °��

      return false  # [Bool]���Ϥ��ʤ����ɤ���
    end

    #=================================================================
    # ��  ��: �������줿�����ɤ�ե����벽����
    #=================================================================
    def output_code_file(cHTMLCode, sFileName)
      check_class(HTMLCode, cHTMLCode) # HTMLCode�Υ��󥹥���
      check_class(String, sFileName)   # ���ϻ��Υե�����̾

      cHTMLCode.output_code_file(sFileName)
    end

    #=================================================================
    # ��  ��: �������������ɥ��饹���֤�
    #=================================================================
    def get_result()
      return @@cHTMLCode  # [HTMLCode]�������������ɥ��饹
    end

  end
end
