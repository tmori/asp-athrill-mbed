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
#  $Id: CBuilder.rb 6 2012-09-03 11:06:01Z nces-shigihara $
#
require "bin/builder/CodeBuilder.rb"
require "bin/product/CCode.rb"

module TTG
  #===================================================================
  # ���饹̾: CBuilder
  # ��    ��: ��֥����ɤ���C�����ɤ����������֤�
  #===================================================================
  class CBuilder < CodeBuilder
    include CommonModule

    #=================================================================
    # ��  ��: ��֥����ɤ���c/h/cfg�ե��������������
    #=================================================================
    def build(cImCode)
      check_class(IntermediateCode, cImCode) # ��֥����ɤΥ��󥹥���

      @aGlobalVar    = cImCode.aGlobalVar.dup()
      @aCode         = cImCode.aCode.dup()
      @hProcUnitInfo = cImCode.hProcUnitInfo.dup()
      @nStack        = cImCode.nStack
      @aHeader       = cImCode.aHeader.dup()
      @hConfig       = cImCode.hConfig.dup()
      @cConf         = Config.new() # ����ե��������
      @sFileName     = @cConf.get_out_file()

      @hEnumData     = Hash.new()  # enum����ѥϥå���

      sCCode      = make_c()
      sHeaderCode = make_header()
      sCfgCode    = make_cfg()

      @@cCode = CCode.new(sCCode, sHeaderCode, sCfgCode)
    end

    #=================================================================
    # ��  ��: cfg�ե�������ʸ��������������֤�
    #=================================================================
    def make_cfg()
      # ���ϥ����ɤ��׻�ʸ����
      sCfgCode = <<-EOS
#{VERSION}
INCLUDE("target_timer.cfg");
INCLUDE("syssvc/syslog.cfg");
INCLUDE("syssvc/serial.cfg");
#include "#{@sFileName}.h"

      EOS

      if (@cConf.is_asp?())
        @hConfig.each{|sClassID, aClassData|
          # ��ŪAPI�ε���
          aClassData.each{|sCode|
            sCfgCode.concat("#{sCode}#{TTG_NL}")
          }
        }
      else
        sCfgCode.concat("INCLUDE(\"target_ipi.cfg\");#{TTG_NL}#{TTG_NL}")
        @hConfig.sort.each{|sClassID, aClassData|
          # �ɤΥ��饹�ˤ�°���ʤ�����ñ�̤ϡ����
          if (sClassID == IMC_NO_CLASS)
            next
          end

          # ���饹�������
          sCfgCode.concat("CLASS(#{sClassID}){#{TTG_NL}")

          # ��ŪAPI�ε���
          aClassData.each{|sCode|
            sCfgCode.concat("#{TTG_TB}#{sCode}#{TTG_NL}")
          }

          # ���饹��������
          sCfgCode.concat("}#{TTG_NL}")
        }
      end

      # FMP�ξ��ǡ��ɤΥ��饹�ˤ�°���ʤ�����ñ��
      if (@cConf.is_fmp?())
        @hConfig.each{|sClassID, aClassData|
          if (sClassID == IMC_NO_CLASS)
            aClassData.each{|sCode|
              sCfgCode.concat("#{sCode}#{TTG_NL}")
            }
          end
        }
      end

      return sCfgCode  # [String]cfg�ե�������ʸ����
    end

    #=================================================================
    # ��  ��: h�ե�������ʸ��������������֤�
    #=================================================================
    def make_header()
      # ���ϥ����ɤ��׻�ʸ����
      sHeaderCode = <<-EOS
#{VERSION}
#include "ttsp_target_test.h"

      EOS

      # ��ͭ�����å������
      if (@cConf.is_stack_share_mode?())
        sHeaderCode.concat("#{TTG_NL}#define TTSP_STACK_SHARE#{TTG_NL}")
        nNum = 1
        while nNum <= @nStack
          sHeaderCode.concat("extern STK_T ttg_stack_#{nNum}[COUNT_STK_T(TTSP_TASK_STACK_SIZE)];#{TTG_NL}")
          nNum += 1
        end
      end

      # enum�����
      if (!@hEnumData.empty?())
        @hEnumData.each{|sEnumID, aTestID|
          sHeaderCode.concat("enum #{sEnumID}{")
          # ��Ƭ��̵���ͤ������
          sHeaderCode.concat("#{TTG_NL}#{TTG_TB}#{sEnumID.sub("ENUM_", "")}_#{TTG_ENUM_INVALID},")
          aTestID.each{|sTestID|
            sHeaderCode.concat("#{TTG_NL}#{TTG_TB}#{sTestID},")
          }
          sHeaderCode.chop!()
          sHeaderCode.concat("#{TTG_NL}};#{TTG_NL}")
        }
        sHeaderCode.concat("#{TTG_NL}")
      end

      @aHeader.sort.each{|sObjID, aArgs|
        if (aArgs.empty?())
          sHeaderCode.concat("extern void #{sObjID}(#{TYP_VOID});#{TTG_NL}")
        else
          sHeaderCode.concat("extern void #{sObjID}(#{aArgs.join(', ')});#{TTG_NL}")
        end
      }

      return sHeaderCode  # [String]h�ե�������ʸ����
    end

    #=================================================================
    # ��  ��: c�ե�������ʸ��������������֤�
    #=================================================================
    def make_c()
      # ���ϥ����ɤ��׻�ʸ����
      sCCode = <<-EOS
#{VERSION}
#include <kernel.h>
#include <t_syslog.h>
#include "syssvc/syslog.h"
#include "kernel_cfg.h"
#include "ttsp_test_lib.h"
#include "#{@sFileName}.h"

      EOS

      # ��ͭ�����å������
      if (@cConf.is_stack_share_mode?())
        nNum = 1
        while nNum <= @nStack
          sCCode.concat("STK_T ttg_stack_#{nNum}[COUNT_STK_T(TTSP_TASK_STACK_SIZE)];#{TTG_NL}")
          nNum += 1
        end
      end

      # GCOV�����������
      if (@cConf.enable_gcov?())
        sGcov = <<-EOS

extern void #{FNC_GCOV_INIT}(void);
extern void #{FNC_GCOV_PAUSE}(void);
extern void #{FNC_GCOV_RESUME}(void);
extern void #{FNC_GCOV_DUMP}(void);
        EOS

        sCCode.concat(sGcov)
      end


      sCCode.concat(make_global_var())
      sCCode.concat(make_function())

      return sCCode  # [String]c�ե�������ʸ����
    end

    #=================================================================
    # ��  ��: �ؿ��Υ�����ʸ��������������֤�
    #=================================================================
    def make_function()
      # �������ѿ��ε���
      @hFuncCode = make_local_var() # ����®�ٸ���Τ��ᥤ�󥹥����ѿ��Ȥ��ư����Ϥ����ʤ�

      # �ץ쥳���ɤ��ɲ�
      @hProcUnitInfo.each{|sObjID, hObjData|
        bPreChk = false
        hObjData[:precode].each{|sCode|
          @hFuncCode[sObjID].push("#{TTG_TB}#{sCode}#{TTG_NL}")
          bPreChk = true
        }
        # �ץ쥳���ɤ������硤�Ǹ�˲��Ԥ������
        if (bPreChk == true)
          @hFuncCode[sObjID].push("#{TTG_NL}")
        end
      }

      # bootcnt��0�Ǥʤ�����ñ�̤�ʣ����ư����Ū�ѿ��Υ��󥯥���Ƚ���
      # (����ߥ����ӥ��롼����ξ���make_block_codet��ǥ��󥯥���Ȥ���)
      @hProcUnitInfo.each{|sObjID, hObjData|
        if ((hObjData[:fbootcnt] > TTG_MAIN_BOOTCNT) && !(sObjID =~ /^#{TTG_LBL_ISR}_.+/))
          @hFuncCode[sObjID].push("#{TTG_TB}#{VAR_BOOTCNT}++;#{TTG_NL}#{TTG_NL}")
        end
      }

      # �ƥ��ȥ��ʥꥪ�оݳ��η���򸺻�
      nCnt = 0
      nTotal = @aCode.size()
      @aCode.each{|hScenarioes|
        hScenarioes.each{|sScenarioID, aScenario|
          GRP_IGNORE_LABEL.each{|sIgnoreLabel|
            if (sScenarioID.include?(sIgnoreLabel))
              nTotal -= 1
              break
            end
          }
        }
      }

      @aCode.each{|hScenarioes|
        hScenarioes.each{|sScenarioID, aScenario|
          bChk = false
          GRP_IGNORE_LABEL.each{|sIgnoreLabel|
            if (sScenarioID.include?(sIgnoreLabel))
              bChk = true
              break
            end
          }
          if (bChk == false)
            nCnt += 1
            if (@cConf.is_no_progress_bar_mode?() == true)
              $stderr.puts "[IMC][#{"%5.1f" % (100 * nCnt.to_f / nTotal.to_f)}\% (#{"%4d" % nCnt}/#{"%4d" % nTotal})] #{sScenarioID}"
            else
              print_progress("IMC", sScenarioID, nCnt, nTotal)
            end
          end

          # �ƥ��ȥ�������ν���
          aScenario.each{|hScenarioData|
            hScenarioData.each{|sConditionID, aConditionData|
              if (sConditionID == IMC_TTG_MAIN)
                make_block_code(aConditionData)
              else
                aConditionData.each{|hBlock|
                  hBlock.each{|sBlockID, aBlockData|
                    make_block_code(aBlockData, sScenarioID)
                  }
                }
              end
            }
          }
        }
      }
      # �ץ��쥹�С���ɽ���Υꥻ�å�
      if (@cConf.is_no_progress_bar_mode?() != true)
        finish_progress("IMC", nTotal)
      end

      # �ݥ��ȥ����ɤ��ɲ�
      @hProcUnitInfo.each{|sObjID, hObjData|
        hObjData[:postcode].each{|sCode|
          @hFuncCode[sObjID].push("#{TTG_TB}#{sCode}#{TTG_NL}")
        }
      }

      # ���ϥ����ɤ��ݻ�����ʸ����
      sFuncCode = ""

      # �إå���ϥå��岽����
      hHeader = {}
      @aHeader.each{|aFuncInfo|
        hHeader[aFuncInfo[0]] = aFuncInfo[1]
      }

      # ����ñ�̤��Ȥ�ʬ�����ϥå���򡤽��Ϥ�����Υ����ɤ˺��
      @hFuncCodeLow = @hFuncCode.sort_by{|key, val| key.downcase }
      @hFuncCodeLow.each{|sObjectID, aCode|
        # �ؿ��������
        if (hHeader[sObjectID.downcase].empty?())
          sFuncCode.concat("void #{sObjectID.downcase}(#{TYP_VOID}){#{TTG_NL}")
        else
          sFuncCode.concat("void #{sObjectID.downcase}(#{hHeader[sObjectID.downcase].join(', ')}){#{TTG_NL}")
        end

        # ���������ɤε���
        aCode.each{ |sCode|
          sFuncCode.concat("#{sCode}")
        }

        # �ؿ���������
        sFuncCode.concat("}#{TTG_NL}#{TTG_NL}")
      }

      return sFuncCode  # [String]�ؿ��Υ�����
    end

    #=================================================================
    # ��  ��: �����Х��ѿ��Υ����ɤ����������֤�
    #=================================================================
    def make_global_var()

      # ���ϥ����ɤ��׻�ʸ����
      sGlobalCode = ""

      @aGlobalVar.each{|sVarName, sVarType, snVarValue|
        # :value���ͤ�¸�ߤ��뤫�ɤ���Ƚ��
        if (snVarValue.nil?())
          sGlobalCode.concat("#{sVarType} #{sVarName};#{TTG_NL}")
        else
          sGlobalCode.concat("#{sVarType} #{sVarName} = #{snVarValue};#{TTG_NL}")
        end
      }

      # ����
      sGlobalCode.concat("#{TTG_NL}")

      return sGlobalCode  # [String]�����Х��ѿ��Υ�����
    end

    #=================================================================
    # ��  ��: �������ѿ��Υ����ɤ����������֤�
    #=================================================================
    def make_local_var()

      # �������Υ����ɤ��ݻ�����ϥå���
      hLocalCode = {}

      @hProcUnitInfo.each{|sObjID, hObjData|
        # �������Ф����ͤ��ʤ���硤��������������
        # (������������ñ�̤��Ф���@hFuncCode�Υ��������������)
        if (hLocalCode[sObjID].nil?())
          hLocalCode[sObjID] = []
        end

        hObjData[:localvar].each{|sVarName, hVarData|
          # :value���ͤ�¸�ߤ��뤫�ɤ���Ƚ��
          if (hVarData[:value].nil?())
            hLocalCode[sObjID].push("#{TTG_TB}#{hVarData[:type]} #{sVarName};#{TTG_NL}")
          else
            hLocalCode[sObjID].push("#{TTG_TB}#{hVarData[:type]} #{sVarName} = #{hVarData[:value]};#{TTG_NL}")
          end
        }

        # ʣ����ư����Ū�ѿ������
        if (hObjData[:fbootcnt] > TTG_MAIN_BOOTCNT)
          hLocalCode[sObjID].push("#{TTG_TB}static int #{VAR_BOOTCNT} = -1;#{TTG_NL}")
        end

        # ����
        hLocalCode[sObjID].push("#{TTG_NL}")
      }

      return hLocalCode  # [String]�������ѿ��Υ�����
    end

    #=================================================================
    # ��  ��: �֥�å��μ¹ԥ����ɤ���������
    #=================================================================
    def make_block_code(aBlockData, sTestID = nil)
      check_class(Array,  aBlockData)    # �֥�å��Υ����ɤΥǡ���
      check_class(String, sTestID, true) # �ƥ���ID

      # �֥�å����Ȥ˲��Ԥ�Ф�����Υ��֥������ȥꥹ��
      aObjList = []

      #nPrcID, sAttr��C�������������ϻ��Ѥ��ʤ�
      aBlockData.each{|sObjID, sCode, nBootCnt, nPrcID, sAttr|
        # ���Ԥ�����륪�֥������ꥹ������
        aObjList.push(sObjID)

        # ����ߥϥ�ɥ顤����ߥ����ӥ��롼����CPU�㳰�ϥ�ɥ��ѽ���
        if ((sObjID =~ /^#{TTG_LBL_INTHDR}_.+/) || (sObjID =~ /^#{TTG_LBL_ISR}_.+/) || (sObjID =~ /^#{TTG_LBL_EXCEPTION}_.+/))
          # ɬ�פ�ʸ�������
          # (����ߥ����ӥ��롼����ξ�硤���֥�������ID���������ID����ʬ������)
          if (sObjID =~ /^#{TTG_LBL_ISR}_.+/)
            sEnumID       = "ENUM_#{TTG_LBL_ISR}"
            sEnumElement  = "#{TTG_LBL_ISR}_#{sTestID}"
            sIfTestID     = "#{TTG_TB}if (#{TTG_LBL_ISR}_#{VAR_BOOTCNT} == #{sEnumElement}) {#{TTG_NL}"
            sEndIfTestID  = "#{TTG_TB}} \/* #{TTG_LBL_ISR}_#{VAR_BOOTCNT} == #{sEnumElement} *\/#{TTG_NL}"
          else
            sEnumObjID    = sObjID
            sEnumID       = "ENUM_#{sEnumObjID}"
            sEnumElement  = "#{sEnumObjID}_#{sTestID}"
            sIfTestID     = "#{TTG_TB}if (#{sEnumObjID}_#{VAR_BOOTCNT} == #{sEnumObjID}_#{sTestID}) {#{TTG_NL}"
            sEndIfTestID  = "#{TTG_TB}} \/* #{sEnumObjID}_#{VAR_BOOTCNT} == #{sEnumObjID}_#{sTestID} *\/#{TTG_NL}"
          end

          sIfBootcnt    = "#{TTG_TB}#{TTG_TB}\/* #{sTestID} *\/#{TTG_NL}#{TTG_TB}#{TTG_TB}if (#{VAR_BOOTCNT} == #{nBootCnt}) {#{TTG_NL}"
          sInitBootcnt  = "#{TTG_TB}#{TTG_TB}#{TTG_TB}#{VAR_BOOTCNT} = -1; \/* #{sTestID} *\/#{TTG_NL}#{TTG_NL}"
          sEndIfBootcnt = "#{TTG_NL}#{TTG_TB}#{TTG_TB}} \/* #{VAR_BOOTCNT} == #{nBootCnt} (#{sTestID}) *\/#{TTG_NL}"

          # enum�ǡ����ν������
          if (!@hEnumData.has_key?(sEnumID))
            @hEnumData[sEnumID] = [sEnumElement]
          # �ǡ������ʤ�����ɲ�
          elsif (!@hEnumData[sEnumID].include?(sEnumElement))
            @hEnumData[sEnumID].push(sEnumElement)
          end

          # �ƥ���ID��ε�ư
          if (!@hFuncCode[sObjID].include?(sIfTestID))
            @hFuncCode[sObjID].push(sIfTestID)

            # ����ߥ����ӥ��롼����ξ���ifʸ����¦�ǹԤ�����
            if (sObjID =~ /^#{TTG_LBL_ISR}_.+/)
              # bootcnt��0�Ǥʤ���硤bootcnt�򥤥󥯥����
              # (¾�Υƥ�����Ǥ�ISR��ư���˥��󥯥���Ȥ����Τ��򤱤�)
              if (@hProcUnitInfo[sObjID][:fbootcnt] > TTG_MAIN_BOOTCNT)
                @hFuncCode[sObjID].push("#{TTG_TB}#{TTG_TB}#{VAR_BOOTCNT}++;#{TTG_NL}#{TTG_NL}")
              end

              # ����Ū�ʳ�����׵᥯�ꥢ����
              # (¾�Υƥ�����Ǥ�ISR��ư���˥��ꥢ�ؿ����¹Ԥ����Τ��򤱤�)
              if (sTestID.include?(TTG_LBL_CHK_ENAINT))
                # �ƥ���ID��TTG_LBL_CHK_ENAINT���ޤޤ����
                snIntNo = sObjID.gsub(/^#{TTG_LBL_ISR}_(.+)_#{TTG_LBL_CHK_ENAINT}$/, "\\1")
              else
                # �ƥ���ID��TTG_LBL_CHK_ENAINT���ޤޤ�ʤ����
                snIntNo = sObjID.gsub(/^#{TTG_LBL_ISR}_(.+)_#{sTestID}_.+$/, "\\1")
              end
              # ���Ф���������ֹ�ǥ��ꥢ�ؿ��¹�
              @hFuncCode[sObjID].push("#{TTG_TB}#{TTG_TB}#{FNC_CLEAR_INT_REQ}(#{snIntNo});#{TTG_NL}#{TTG_NL}")
            end
          end

            # ʣ����ư
            if (@hProcUnitInfo["#{sObjID}"][:fbootcnt] == TTG_MAIN_BOOTCNT)
              @hFuncCode[sObjID].push("#{TTG_TB}#{TTG_TB}#{sCode}#{TTG_NL}")
            else
              if (!@hFuncCode[sObjID].include?(sIfBootcnt))
                @hFuncCode[sObjID].push(sIfBootcnt)
                @hFuncCode[sObjID].delete(sInitBootcnt)
                @hFuncCode[sObjID].push(sInitBootcnt)
              end

              @hFuncCode[sObjID].push("#{TTG_TB}#{TTG_TB}#{TTG_TB}#{sCode}#{TTG_NL}")

              if (@hFuncCode[sObjID].include?(sEndIfBootcnt))
                @hFuncCode[sObjID].delete(sEndIfBootcnt)
              end

              @hFuncCode[sObjID].push(sEndIfBootcnt)
            end

          if (@hFuncCode[sObjID].include?(sEndIfTestID))
            @hFuncCode[sObjID].delete(sEndIfTestID)
          end

          @hFuncCode[sObjID].push(sEndIfTestID)
        # �̾�Υ�����������
        else
          # ɬ�פ�ʸ�������
          sIfBootcnt    = "#{TTG_TB}if (#{VAR_BOOTCNT} == #{nBootCnt}) {#{TTG_NL}"
          sEndIfBootcnt = "#{TTG_TB}} \/* #{VAR_BOOTCNT} == #{nBootCnt} *\/#{TTG_NL}"

          # ʣ����ư�γ�ǧ
          if (@hProcUnitInfo[sObjID][:fbootcnt] == TTG_MAIN_BOOTCNT)
            @hFuncCode[sObjID].push("#{TTG_TB}#{sCode}#{TTG_NL}")
          else
            if (!@hFuncCode[sObjID].include?(sIfBootcnt))
              @hFuncCode[sObjID].push(sIfBootcnt)
            end

            @hFuncCode[sObjID].push("#{TTG_TB}#{TTG_TB}#{sCode}#{TTG_NL}")

            if (@hFuncCode[sObjID].include?(sEndIfBootcnt))
              @hFuncCode[sObjID].delete(sEndIfBootcnt)
            end

            @hFuncCode[sObjID].push(sEndIfBootcnt)
          end
        end
      }

      # �֥�å���Υ��֥���������˲��Ԥ������
      aObjList.uniq.each{|sObjID|
        @hFuncCode[sObjID].push("#{TTG_NL}")
      }
    end

    #=================================================================
    # ��  ��: �������������ɤ�ե����벽����
    #=================================================================
    def output_code_file(cCCode, sFileName)
      check_class(CCode, cCCode)    # CCode�Υ��󥹥���
      check_class(String, sFileName) # ���ϻ��Υե�����̾

      cCCode.output_code_file(sFileName)
    end

    #=================================================================
    # ��  ��: �������������ɥ��饹���֤�
    #=================================================================
    def get_result()
      return @@cCode  # [CCode]�������������ɥ��饹
    end
  end
end
