#!ruby -Ke
#
#  TTG
#      TOPPERS Test Generator
#
#  Copyright (C) 2009-2012 by Center for Embedded Computing Systems
#              Graduate School of Information Science, Nagoya Univ., JAPAN
#  Copyright (C) 2010-2011 by Digital Craft Inc.
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
#  $Id: TestScenario.rb 9 2012-09-11 01:47:48Z nces-shigihara $
#
require "common/bin/test_scenario/TestScenario.rb"
require "ttj/bin/class/TTJModule.rb"

#=====================================================================
# CommonModule
#=====================================================================
module CommonModule
  #===================================================================
  # ���饹̾: TestScenario
  # ��    ��: PreCondition��Do��PostCondition�Υǡ������ݻ�
  #===================================================================
  class TestScenario
    include CommonModule
    include TTJModule

    #=================================================================
    # ������: TestScenario��TESRY�����ɾ�������ܸ첽���ƥƥ���ID��
    #         �����֤�
    #=================================================================
    def japanize_tesry_info()
      sVariation = ""
      sTTJPre    = ""
      sTTJDoPost = ""

      # Variation����
      if (hVariation.empty?() == false)
        sVariation = japanize_variation_info()
      end

      # pre_condition����
      sTTJPre = cPreCondition.japanize_pre_info()

      # do��post_condition�Υ��������ֹ�ȥ�����ƥ��å������
      # 2��������ǹԤϥ��������ֹ����ϥ�����ƥ��å��򼨤�
      aSteps = []

      aDo_PostCondition.each{|cDo_PostCondition|
        if (aSteps[cDo_PostCondition.nSeqNum].nil?() == true)
          aSteps[cDo_PostCondition.nSeqNum] = []  # ���������ֹ�μ���
        end

        aSteps[cDo_PostCondition.nSeqNum].push(cDo_PostCondition.nTimeTick)  # ������ƥ��å��μ���
      }

      # ���������ֹ�ȥ�����ƥ��å���񤯤���ν���
      # ���������ֹ�ȥ�����ƥ��å��ˤ��do��post_condition�ξ�������ܸ첽����
      bSeqNum   = false  # ���������ֹ椬ʣ�����뤫ñ�줢�뤫�򼨤��ե饰
      bTickFlag = false  # ������ƥ��å�ȯ�Ը夫��ξ���ˤ�ɬ��������ƥ��å���񤯤��Ȥ򼨤��ե饰
      bCondFlag = true   # condition��do��񤯤��񤫤ʤ����򼨤��ե饰

      if (aSteps.size() > 1)
        bSeqNum = true  # ���������ֹ椬ʣ��������ϥ��������ֹ椬ʣ�����뤳�Ȥ򼨤��ե饰
      end

      aSteps.each_index{|nSeq|
        if (aSteps[nSeq].size() > 1) || (bTickFlag == true)  # �������륷�������ֹ�˾���ʣ���ξ��
          aSteps[nSeq].each{|nTick|  # do�ν���
            bTimeTick = search_do_info(nSeq)  # do��ʣ���ν��������뤫�����å�
            cDo_PostCondition = search_do_post_condition(nSeq, nTick)  # ��������do�����
            sTTJDoPost += cDo_PostCondition.japanize_do_info(bSeqNum, (bTickFlag == true) ? bTickFlag : bTimeTick, bCondFlag)  # ���ܸ첽
            bCondFlag = false  # �ֽ����פ������񤫤�ʤ��褦�ˤ��뤿��
          }

          bCondFlag = true

          aSteps[nSeq].each{|nTick|  # post_condition�ν���
            cDo_PostCondition = search_do_post_condition(nSeq, nTick)  # ��������post_condition�����
            sTTJDoPost += cDo_PostCondition.japanize_post_info(bSeqNum, true, bCondFlag)  # ���ܸ첽
            bCondFlag = false  # �ָ���֡פ������񤫤�ʤ��褦�ˤ��뤿��
          }

          bCondFlag = true
          bTickFlag = true
        else  # �������륷�������ֹ�˾��󤬰�ĤΤߤξ��
          cDo_PostCondition = search_do_post_condition(nSeq)
          sTTJDoPost += cDo_PostCondition.japanize_do_info(bSeqNum, false, bCondFlag)
          sTTJDoPost += cDo_PostCondition.japanize_post_info(bSeqNum, false, bCondFlag)
        end
      }

      # ���ܸ첽����TESRY�����ɤξ����ϥå���ˤޤȤ��
      hJapanizeInfo = {@sTestID => sVariation + sTTJPre + sTTJDoPost}

      return hJapanizeInfo  # [Hash]�ƥ���ID(key)�����ܸ첽����(val)��ϥå���ˤ����֤�
    end

    #=================================================================
    # ������: variation�����ܸ첽����
    #=================================================================
    def japanize_variation_info()
      sIndent       = "#{TTJ_TAB}"
      sAllVariation = "#{GRP_TTJ_CONDITION[TSR_LBL_VARIATION]}#{TTJ_NEW_LINE}"

      # Blank�Υ������׻�
      blank_size = 1

      @hVariation.each{|key, val|
        if (GRP_TTJ_VARIATION[key].nil?() == true)
          $sAttrErr += "[variation : #{key}] #{@sTestID}#{TTJ_NEW_LINE}"  # ���ꤵ��Ƥ��ʤ�°���Υ��顼����
        elsif (GRP_TTJ_STATUS[val].nil?() == true)
          $sAttrErr += "[variation/#{key} : #{val}] #{@sTestID}#{TTJ_NEW_LINE}"  # ���ꤵ��Ƥ��ʤ�°���Υ��顼����
        elsif (blank_size < GRP_TTJ_VARIATION[key].size())
          blank_size = GRP_TTJ_VARIATION[key].size()  # ����Ĺ��°���Υ��������������
        end
      }

      # Variation�����ܸ첽
      @hVariation.each{|key, val|
        blank = ""

        if (GRP_TTJ_VARIATION[key].nil?() == true)
          next
        else
          (blank_size - GRP_TTJ_VARIATION[key].size()).times {
            blank += TTJ_BLINK_INDEX  # Blank����
          }
        end

        # °�����ͤ�true��false�ξ��
        if ((key == TSR_PRM_GAIN_TIME)       || (key == TSR_PRM_ENA_EXC_LOCK)    || (key == TSR_PRM_GCOV_ALL) ||
            (key == TSR_PRM_SUPPORT_GET_UTM) || (key == TSR_PRM_SUPPORT_ENA_INT) || (key == TSR_PRM_SUPPORT_DIS_INT))
          sAllVariation += "#{sIndent}#{GRP_TTJ_VARIATION[key]}#{blank}#{TTJ_PARTITION}#{GRP_TTJ_STATUS[val][key]}#{TTJ_NEW_LINE}"
        else
          sAllVariation += "#{sIndent}#{GRP_TTJ_VARIATION[key]}#{blank}#{TTJ_PARTITION}#{GRP_TTJ_STATUS[val]}#{TTJ_NEW_LINE}"
        end
      }

      sAllVariation += "#{TTJ_NEW_LINE}"

      return sAllVariation  # [String]�Хꥨ�����������ܸ첽����ʸ����
    end

    #=================================================================
    # ������: nSeqNum��nTimeTick�˳�������cDo_PostCondition��
    #         �������ƾä�
    #=================================================================
    def search_do_post_condition(nSeq, nTick = nil)
      check_class(Integer, nSeq)         # ���������ֹ�
      check_class(Integer, nTick, true)  # ������ƥ��å�

      aDo_PostCondition.each{|cDo_PostCondition|
        if ((nTick.nil?() == true) && (cDo_PostCondition.nSeqNum == nSeq))
          return cDo_PostCondition  # [cDo_PostCondition]Do��PostCondition����Υ��饹
        elsif ((cDo_PostCondition.nSeqNum == nSeq) && (cDo_PostCondition.nTimeTick == nTick))
          return cDo_PostCondition  # [cDo_PostCondition]Do��PostCondition����Υ��饹
        end
      }
    end

    #=================================================================
    # ������: ��������nSeqNum��do�ξ���ʣ�����뤫�ɤ������������֤�
    #=================================================================
    def search_do_info(nSeq)
      check_class(Integer, nSeq)  # ���������ֹ�

      # do��ʣ���ν��������뤫�����å�����
      # ʣ���ξ���true��ñ��ξ���false���֤�
      aDoInfo = []

      aDo_PostCondition.each{|cDo_PostCondition|
        if ((cDo_PostCondition.nSeqNum == nSeq) && (cDo_PostCondition.hDo.empty?() == false))
          aDoInfo.push(cDo_PostCondition.nTimeTick)
        end
      }

      bDoFlag = (aDoInfo.size() > 1) ? true : false

      return bDoFlag  # [Bool]Do�ξ���ʣ���ξ���true��ʣ���ǤϤʤ�����false���֤�
    end

  end
end
